extends Spatial


func _on_Player_view_switched(view):
	if view == Enums.VIEW_MODES.TPV:
		$UI/OverlayCanvas/DebugUI.hide()
		$UI/OverlayCanvas/DriverDash.hide()
	else:
		$UI/OverlayCanvas/DebugUI.show()
		$UI/OverlayCanvas/DriverDash.show()
