extends RigidBody

signal notification(message)
signal view_switched(view)
signal direction_update(direction)
signal torque_update(direction)

var rotation_speed: float = 100.0
var boost_force: float = 200.0
onready var view_mode = Enums.VIEW_MODES.FPV


# y is up and down
var last_burn_rotation: float = 0.0

onready var stars: Node = $Stars;
onready var tp_camera_pivot: Node = $CameraPivot
onready var tp_camera: Camera = $CameraPivot/TPCamera
onready var fp_camera: Camera = $FPCamera
onready var starting_pos: Vector3 = translation




func _process(delta):
	if Input.is_action_just_released("view_change"):
		toggle_view()

func _physics_process(delta):
	var torque = Vector3.ZERO
	var burn_dir = null
	var torque_type = null
	var dir_type = null
	
	# if in FPV you can drive
	# if camera in TPV is locked you can drive in FPV
	if view_mode == Enums.VIEW_MODES.FPV or tp_camera_pivot.is_locked():
		var inputs =  get_driving_inputs()
		torque = inputs[0]
		torque_type = inputs[1]
		burn_dir = inputs[2]
		dir_type = inputs[3]
	
	# this is so upper view camera wont rotate
	if torque != Vector3.ZERO:
#		maybe can move this to a toggle too ?
#		$CameraPivot.rotation = -rotation

#		This is to keep the skybox rotated if the ship is toquing
		stars.rotation.y = clamp(-rotation.y, -360, 360);
		add_torque(torque * rotation_speed * delta)
		emit_signal("torque_update", torque_type)
	
	if burn_dir != null:
		add_central_force(burn_dir * boost_force * delta)
		emit_signal("direction_update", dir_type)

func get_driving_inputs() -> Array:
	var torque = Vector3.ZERO
	var torque_type = Enums.DIRECTIONS.NONE
	
	if Input.is_action_pressed("right"):
		torque.y = -1
		torque_type = Enums.DIRECTIONS.RIGHT
	elif Input.is_action_pressed("left"):
		torque.y = 1
		torque_type = Enums.DIRECTIONS.LEFT
	
	
	var is_toggled = Input.is_action_pressed("toggle_space")
	var force = Vector3.ZERO
	var burn_dir = null
	var dir_type = null
	
	if Input.is_action_pressed("up"):
		last_burn_rotation = rotation.y
		burn_dir = -1
		dir_type = Enums.DIRECTIONS.FORWARD
		$BackLight/Wake/Particles.emitting = true
	elif Input.is_action_pressed("down"):
		last_burn_rotation = rotation.y
		burn_dir = 1
		dir_type = Enums.DIRECTIONS.BACK
	
	if Input.is_action_just_released("up"):
		$BackLight/Wake/Particles.emitting = false
		
	
	if burn_dir != null:
		var x_dir = sin(last_burn_rotation) if !is_toggled else 0
		var z_dir = cos(last_burn_rotation) if !is_toggled else 0
		var y_dir = 0 if !is_toggled else -1
		dir_type = dir_type if !is_toggled else Enums.DIRECTIONS.UP if burn_dir == -1 else Enums.DIRECTIONS.DOWN
		burn_dir = (Vector3(x_dir, y_dir, z_dir) * burn_dir).normalized()
		
		
	return [torque, torque_type, burn_dir, dir_type]

func toggle_view():
	if view_mode == Enums.VIEW_MODES.FPV:
		tp_camera.current = true
		fp_camera.current = false
		view_mode = Enums.VIEW_MODES.TPV
		tp_camera_pivot.toggle_tpv()
	else:
		fp_camera.current = true
		tp_camera.current = false
		view_mode = Enums.VIEW_MODES.FPV
		tp_camera_pivot.toggle_tpv()
	
	emit_signal("view_switched", view_mode)
		

func notify(message):
	emit_signal("notification", message)
