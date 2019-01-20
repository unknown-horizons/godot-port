extends Control

var _scenes = {
	world = preload("res://Assets/World/World.tscn"),
	exit = preload("res://Assets/UI/Scenes/ExitScene.tscn")
}

func _input(event):
	if not event is InputEventKey and not event is InputEventMouseButton:
		return
	
	# Set the animation mark to the very end, so all final values are stil set.
	var animation_player = $AnimationPlayer
	animation_player.seek(animation_player.current_animation_length)
	
	accept_event() # Avoid triggering buttons on intro skip.
	set_process_input(false)

func _go_to_scene(scene):
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to(_scenes[scene])
