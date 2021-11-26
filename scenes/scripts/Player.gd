extends RigidBody

signal view_switched(view)
signal direction_update(direction)
signal torque_update(direction)

var rotation_speed: float = 100.0
var boost_force: float = 200.0
onready var view_mode = Enums.VIEW_MODES.FPV


# y is up and down
var last_burn_rotation: float = 0.0

var camera_rotation_speed:float = 1.0
onready var tp_camera: Camera = $CameraPivot/TPCamera
onready var fp_camera: Camera = $FPCamera
onready var starting_pos: Vector3 = translation



func _process(delta):
	if Input.is_action_just_released("view_change"):
		toggle_view()
	
	if view_mode == Enums.VIEW_MODES.TPV:
		check_tpv_camera_input()

func _physics_process(delta):
	var torque = Vector3.ZERO
	var burn_dir = null
	var torque_type = null
	var dir_type = null
	
	# if in FPV you can drive
	if view_mode == Enums.VIEW_MODES.FPV:
		var inputs =  get_driving_inputs()
		torque = inputs[0]
		torque_type = inputs[1]
		burn_dir = inputs[2]
		dir_type = inputs[3]
	
	# this is so upper view camera wont rotate
	if torque != Vector3.ZERO:
		$CameraPivot.rotation = -rotation
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
	
	
	var is_toggled = Input.is_action_pressed("toggle")
	var force = Vector3.ZERO
	var burn_dir = null
	var dir_type = null
	
	if Input.is_action_pressed("burn"):
		last_burn_rotation = rotation.y
		burn_dir = -1
		dir_type = Enums.DIRECTIONS.FORWARD
	elif Input.is_action_pressed("counter_burn"):
		last_burn_rotation = rotation.y
		burn_dir = 1
		dir_type = Enums.DIRECTIONS.BACK
		
	
	if burn_dir != null:
		var x_dir = sin(last_burn_rotation) if !is_toggled else 0
		var z_dir = cos(last_burn_rotation) if !is_toggled else 0
		var y_dir = 0 if !is_toggled else -1
		dir_type = dir_type if !is_toggled else Enums.DIRECTIONS.UP if burn_dir == -1 else Enums.DIRECTIONS.DOWN
		burn_dir = (Vector3(x_dir, y_dir, z_dir) * burn_dir).normalized()
		
		
	return [torque, torque_type, burn_dir, dir_type]

func check_tpv_camera_input():
	# maybe those need to rotate with delta on an axis only maybe
	# also might need to rotate camera too as it seems to be upside down
	if Input.is_action_just_released("right"):
		$CameraPivot.rotation_degrees.x = 0
		$CameraPivot.rotation_degrees.z = -90
		$CameraPivot/TPCamera.translation.y = 10
	elif Input.is_action_just_released("left"):
		$CameraPivot.rotation_degrees.x = 0
		$CameraPivot.rotation_degrees.z = 90
		$CameraPivot/TPCamera.translation.y = 10
	elif Input.is_action_just_released("burn"):
		$CameraPivot.rotation_degrees.z = 0
		$CameraPivot.rotation_degrees.x = 90
		$CameraPivot/TPCamera.translation.y = 10
	elif Input.is_action_just_released("counter_burn"):
		$CameraPivot.rotation_degrees.x = -90
		$CameraPivot.rotation_degrees.z = 0
		$CameraPivot/TPCamera.translation.y = 10
	elif Input.is_action_just_released("toggle"):
		$CameraPivot.rotation_degrees.x = 0
		$CameraPivot.rotation_degrees.z = 0
		$CameraPivot/TPCamera.translation.y = 100

func toggle_view():
	if view_mode == Enums.VIEW_MODES.FPV:
		tp_camera.current = true
		fp_camera.current = false
		view_mode = Enums.VIEW_MODES.TPV
	else:
		fp_camera.current = true
		tp_camera.current = false
		view_mode = Enums.VIEW_MODES.FPV
	
	emit_signal("view_switched", view_mode)
		
