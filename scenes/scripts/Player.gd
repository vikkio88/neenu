extends RigidBody

enum ViewMode {
	FPV,
	TPV
}

enum DIRECTIONS {
	UP,
	DOWN,
	FORWARD,
	BACK,
	LEFT,
	RIGHT,
	NONE
}

signal view_switched(view)
signal direction_update(direction)
signal torque_update(direction)

var rotation_speed: float = 100.0
var boost_force: float = 200.0
var view_mode = ViewMode.FPV


# y is up and down
var last_burn_rotation: float = 0.0

onready var tp_camera: Camera = $CameraPivot/TPCamera
onready var fp_camera: Camera = $FPCamera
onready var starting_pos: Vector3 = translation

func _process(delta):
	if Input.is_action_just_released("view_change"):
		toggle_view()

func _physics_process(delta):
	
	var torque = Vector3.ZERO
	var torque_type = DIRECTIONS.NONE
	
	if Input.is_action_pressed("right"):
		torque.y = -1
		torque_type = DIRECTIONS.RIGHT
	elif Input.is_action_pressed("left"):
		torque.y = 1
		torque_type = DIRECTIONS.LEFT
	
	# this is so upper view camera wont rotate
	$CameraPivot.rotation = -rotation
	if torque != Vector3.ZERO:
		add_torque(torque * rotation_speed * delta)
		emit_signal("torque_update", torque_type)
	
	var is_toggled = Input.is_action_pressed("toggle")
	var force = Vector3.ZERO
	var burn_dir = 0
	var dir_type = null
	
	if Input.is_action_pressed("burn"):
		last_burn_rotation = rotation.y
		burn_dir = -1
		dir_type = DIRECTIONS.FORWARD
	elif Input.is_action_pressed("counter_burn"):
		last_burn_rotation = rotation.y
		burn_dir = 1
		dir_type = DIRECTIONS.BACK
		
	
	
	if burn_dir != 0:
		var x_dir = sin(last_burn_rotation) if !is_toggled else 0
		var z_dir = cos(last_burn_rotation) if !is_toggled else 0
		var y_dir = 0 if !is_toggled else -1
		dir_type = dir_type if !is_toggled else DIRECTIONS.UP if burn_dir == -1 else DIRECTIONS.DOWN
		
		force = (burn_dir * Vector3(x_dir, y_dir, z_dir)).normalized()
		add_central_force(force * boost_force * delta)
		emit_signal("direction_update", dir_type)

func toggle_view():
	if view_mode == ViewMode.FPV:
		tp_camera.current = true
		fp_camera.current = false
		view_mode = ViewMode.TPV
	else:
		fp_camera.current = true
		tp_camera.current = false
		view_mode = ViewMode.FPV
	
	emit_signal("view_switched", view_mode)
		
