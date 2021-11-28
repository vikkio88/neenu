extends Control

onready var player: RigidBody = $"/root/MainScene/Player"
onready var speedLbl: Label = $Speed
onready var distanceLbl: Label = $Distance

onready var main: Spatial = $"/root/MainScene"
onready var bigSphereScn = load("res://scenes/tests/BigSphere.tscn")
onready var sphereScn = load("res://scenes/tests/Sphere.tscn")

func _ready():
	var rng = RandomNumberGenerator.new()
	
	for i in range(40):
		var s = sphereScn.instance()
		s.translation = Vector3(0, 0, -30 * (i+1))
		# if you dont defer this main is not ready to add
		main.call_deferred("add_child", s)
	
	
	for i in range(40):
		var x = rng.randi_range(0, 10)
		var y = rng.randi_range(0, 20)
		var z = rng.randi_range(0, 10)
		
		var s = sphereScn.instance()
		s.translation = Vector3(-30 * (i+1) + x, y, -30 * (i+1) + z)
		# if you dont defer this main is not ready to add
		main.call_deferred("add_child", s)


func _process(delta):
	if Input.is_action_just_released("QUIT"):
		get_tree().quit()

func _on_DebugTick_timeout():
	speedLbl.text = "speed: " + str(player.linear_velocity) +" ang: "+ str(player.angular_velocity) + " - " +str(player.linear_velocity.length())
	distanceLbl.text = "distance: " + str(player.starting_pos - player.translation)
	
