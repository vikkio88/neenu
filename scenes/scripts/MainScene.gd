extends Spatial


func _on_Player_view_switched(view):
	if view == 1:
		$UI/OverlayCanvas/DebugUI.hide()
	else:
		$UI/OverlayCanvas/DebugUI.show()
