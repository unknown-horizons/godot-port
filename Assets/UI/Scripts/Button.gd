extends TextureButton
class_name SimpleButton

func _on_Button_pressed() -> void:
	Audio.play_snd_click()
