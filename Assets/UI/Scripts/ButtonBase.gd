extends TextureButton
class_name ButtonBase

func _on_ButtonBase_pressed() -> void:
	Audio.play_snd_click()
