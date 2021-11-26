extends Spatial


const CAMERA_SPEED:float = 100.0
const CAMERA_MAX_DISTANCE: float = 100.0
const CAMERA_MIN_DISTANCE: float = 20.0

var tpv_camera_enabled = false

onready var camera = $TPCamera

func toggle_tpv():
	tpv_camera_enabled = not tpv_camera_enabled
	
	if not tpv_camera_enabled:
		reset_view()

func _process(delta):
	if not tpv_camera_enabled:
		return
	
	check_tpv_camera_input(delta)
	
func reset_view():
	rotation_degrees.x = 0
	rotation_degrees.z = 0
	camera.translation.y = CAMERA_MAX_DISTANCE

func check_tpv_camera_input(delta):
	if Input.is_action_pressed("right"):
		rotation_degrees.z -= CAMERA_SPEED * delta
	elif Input.is_action_pressed("left"):
		rotation_degrees.z += CAMERA_SPEED * delta
	elif Input.is_action_pressed("burn"):
		camera.translation.y -= CAMERA_SPEED * delta
		camera.translation.y = clamp(camera.translation.y, CAMERA_MIN_DISTANCE, CAMERA_MAX_DISTANCE)
	elif Input.is_action_pressed("counter_burn"):
		camera.translation.y += CAMERA_SPEED * delta
		camera.translation.y = clamp(camera.translation.y, CAMERA_MIN_DISTANCE, CAMERA_MAX_DISTANCE)
	elif Input.is_action_just_released("toggle"):
		reset_view()
