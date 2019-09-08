extends Button

func _pressed() -> void:
	# Go back to the main menu.
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to(
			preload("res://Assets/UI/Scenes/MainMenuScene.tscn"))
