extends Control

func report_direction(direction, active):
	var green = Color(0,.7,0)
	reset_directions()
	match direction:
		Enums.DIRECTIONS.FORWARD:
			$Forward.color = green
		Enums.DIRECTIONS.BACK:
			$Back.color = green
		Enums.DIRECTIONS.UP:
			$Up.color = green
		Enums.DIRECTIONS.DOWN:
			$Down.color = green
		Enums.DIRECTIONS.LEFT:
			$Left.color = green
		Enums.DIRECTIONS.RIGHT:
			$Right.color = green
		_:
			pass
	
	$Clock.start()
			
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


func _on_Clock_tick():
	reset_directions()
