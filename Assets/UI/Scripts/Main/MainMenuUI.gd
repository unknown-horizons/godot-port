extends Control

const _scenes = {
	world = preload("res://Assets/World/World.tscn"),
	exit = preload("res://Assets/UI/Scenes/ExitScene.tscn")
}

func _go_to_scene(scene):
	get_tree().change_scene_to(_scenes[scene])
