extends Control

onready var player: RigidBody = $"/root/MainScene/Player"
onready var speedLbl: Label = $Speed
onready var distanceLbl: Label = $Distance

onready var main: Spatial = $"/root/MainScene"
onready var bigSphereScn = load("res://scenes/tests/BigSphere.tscn")
onready var sphereScn = load("res://scenes/tests/Sphere.tscn")

func _ready():
	for i in range(10):
		var s = sphereScn.instance()
		s.translation = Vector3(0, 0, -30 * (i+1))
		# if you dont defer this main is not ready to add
		main.call_deferred("add_child", s)



func _process(delta):
	if Input.is_action_just_released("QUIT"):
		get_tree().quit()

func _on_DebugTick_timeout():
	speedLbl.text = "speed: " + str(player.linear_velocity) + str(player.angular_velocity)
	distanceLbl.text = "distance: " + str(player.starting_pos - player.translation)
	
