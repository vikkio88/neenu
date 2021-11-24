extends Control

enum DIRECTIONS {
	UP,
	DOWN,
	FORWARD,
	BACK,
	LEFT,
	RIGHT,
	NONE
}

func report_direction(direction, active):
	var green = Color(0,.7,0)
	reset_directions()
	match direction:
		DIRECTIONS.FORWARD:
			$Forward.color = green
		DIRECTIONS.BACK:
			$Back.color = green
		DIRECTIONS.UP:
			$Up.color = green
		DIRECTIONS.DOWN:
			$Down.color = green
		DIRECTIONS.LEFT:
			$Left.color = green
		DIRECTIONS.RIGHT:
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
