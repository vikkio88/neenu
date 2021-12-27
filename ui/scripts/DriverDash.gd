extends Control

var directions_pushed = Array();

func report_direction(direction, active):
	var green = Color(0,.7,0)
	var node = null
	
	if direction == Enums.DIRECTIONS.FORWARD:
		node = $Forward
	if direction == Enums.DIRECTIONS.BACK:
		node = $Back
	if direction == Enums.DIRECTIONS.UP:
		node = $Up
	if direction == Enums.DIRECTIONS.DOWN:
		node = $Down
	if direction == Enums.DIRECTIONS.LEFT:
		node = $Left
	if direction == Enums.DIRECTIONS.RIGHT:
		node = $Right
	
	if node !=  null:
		node.color = green
		if directions_pushed.back() != node:
			directions_pushed.push_back(node)
	
			
func reset_directions():
	var base_color = Color(1,1,1)
	
	$Forward.color = base_color
	$Back.color = base_color
	$Right.color = base_color
	$Left.color = base_color
	$Up.color = base_color
	$Down.color = base_color

func _on_Player_direction_update(direction):
	report_direction(direction, true)


func _on_Player_torque_update(direction):
	report_direction(direction, true)

func on_message(message):
	$MessageLbl.text = message
	$MessageResetClock.start()

func reset_message():
	$MessageLbl.text = ''

func _on_DirectionsResetClock_timeout():
	if directions_pushed.size() > 0:
		var indicator: ColorRect = directions_pushed.pop_front()
		indicator.color = Color(1,1,1)


func _on_MessageResetClock_timeout():
	reset_message()
