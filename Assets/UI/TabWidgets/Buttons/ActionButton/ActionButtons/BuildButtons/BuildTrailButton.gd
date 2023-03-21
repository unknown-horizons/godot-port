extends WidgetButton

func _on_ActionButton_gui_input(_event: InputEvent):
	if _event.is_action_type():
		var PlayerCamera = find_parent("PlayerCamera")
		PlayerCamera.switch_context(PlayerCamera.find_child("TileContext"))
