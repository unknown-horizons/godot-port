extends Button

var scene : PackedScene = load("res://Assets/World/World.tscn")

func _pressed():
	var _stfu = get_tree().change_scene_to(scene)
	pass
