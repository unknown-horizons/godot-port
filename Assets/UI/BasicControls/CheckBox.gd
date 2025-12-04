extends CheckBox

func _on_CheckBox_toggled(_button_pressed: bool) -> void:
	if has_focus():
		Audio.play_snd_click()
