extends Button

var scene : PackedScene = load("res://Assets/UI/Scenes/ExitScene.tscn")

func _pressed():
	var _stfu = get_tree().change_scene_to(scene)
	pass
