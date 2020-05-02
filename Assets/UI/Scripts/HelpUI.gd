extends Control
class_name HelpUI

var parent = null

func _on_Button_pressed():
	Audio.play_snd_click()
	parent.visible = true
	queue_free()
