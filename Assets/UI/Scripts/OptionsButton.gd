extends Button
class_name OptionsButton
signal button(option_name)

func _on_Button_pressed(option_name) -> void:
	Audio.play_snd_click()
	emit_signal("button", option_name)
