extends Spatial


const CAMERA_SPEED:float = 100.0
const CAMERA_MAX_DISTANCE: float = 100.0
const CAMERA_MIN_DISTANCE: float = 20.0

var tpv_camera_enabled = false
var tp_camera_mode = Enums.TP_CAMERA_MODES.LOCKED

onready var camera = $TPCamera
onready var player = $".."

func toggle_tpv():
	tpv_camera_enabled = not tpv_camera_enabled
	
	# reset view by default if switching camera
	if not tpv_camera_enabled:
		reset_view()
	
func toggle_camera_mode():
	# maybe need to add some prompt to show this toggle action
	# also need to relay this info to Dash
	if tp_camera_mode == Enums.TP_CAMERA_MODES.LOCKED:
		tp_camera_mode = Enums.TP_CAMERA_MODES.ACTIVE
		player.notify("Camera Mode: ACTIVE")
	elif tp_camera_mode == Enums.TP_CAMERA_MODES.ACTIVE:
		tp_camera_mode = Enums.TP_CAMERA_MODES.LOCKED
		player.notify("Camera Mode: LOCKED")

func is_locked() -> bool:
	return tp_camera_mode == Enums.TP_CAMERA_MODES.LOCKED

func is_active() -> bool:
	return tp_camera_mode == Enums.TP_CAMERA_MODES.ACTIVE

func _process(delta):
	if not tpv_camera_enabled:
		return
	
	if Input.is_action_just_released("reset"):
		reset_view()
	
	if Input.is_action_just_released("toggle_c"):
		toggle_camera_mode()
	
	if is_active():
		check_tpv_camera_input(delta)
	
		
func reset_view():
	player.notify("Camera View: RESET")
	rotation_degrees.x = 0
	rotation_degrees.z = 0
	camera.translation.y = CAMERA_MAX_DISTANCE

func check_tpv_camera_input(delta):
	if Input.is_action_pressed("right"):
		rotation_degrees.z -= CAMERA_SPEED * delta
	elif Input.is_action_pressed("left"):
		rotation_degrees.z += CAMERA_SPEED * delta
	elif Input.is_action_pressed("up"):
		camera.translation.y -= CAMERA_SPEED * delta
		camera.translation.y = clamp(camera.translation.y, CAMERA_MIN_DISTANCE, CAMERA_MAX_DISTANCE)
	elif Input.is_action_pressed("down"):
		camera.translation.y += CAMERA_SPEED * delta
		camera.translation.y = clamp(camera.translation.y, CAMERA_MIN_DISTANCE, CAMERA_MAX_DISTANCE)
	
