extends TextureButton
class_name SimpleButton
signal config_done()

func _on_Button_pressed() -> void:
	Audio.play_snd_click()
	var saved = Global.save_config()
	if saved != OK:
		print("Could not save config!")
	emit_signal("config_done")
