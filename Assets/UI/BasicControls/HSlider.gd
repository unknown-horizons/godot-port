extends HSlider

func _on_HSlider_value_changed(_value: float) -> void:
	if has_focus():
		Audio.play_snd_click()
