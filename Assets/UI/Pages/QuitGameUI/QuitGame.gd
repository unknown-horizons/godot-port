extends Button

func _pressed() -> void:
	# Go back to the main menu.
	get_tree().change_scene_to_packed(
		preload("res://Assets/UI/Pages/MainMenuScene.tscn"))
