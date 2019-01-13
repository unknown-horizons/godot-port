extends Button

var scene = load("res://Assets/UI/Scenes/MainMenuScene.tscn") # : PackedScene

func _pressed():
	var _stfu = get_tree().change_scene_to(scene)
	pass
