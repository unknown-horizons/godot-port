extends Button

var _scene = preload("res://Assets/UI/Scenes/MainMenuScene.tscn") # : PackedScene

func _pressed():
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to(_scene)
