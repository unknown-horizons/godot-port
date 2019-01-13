extends BaseButton

var scene = load("res://Assets/World/World.tscn") # : PackedScene

func _pressed():
	var _stfu = get_tree().change_scene_to(scene)
	pass
