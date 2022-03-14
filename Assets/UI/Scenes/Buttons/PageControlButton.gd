extends ButtonBase
class_name PageControlButton

func _on_ButtonBase_pressed() -> void:
	Audio.play_snd("flippage")
