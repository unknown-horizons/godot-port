extends Control
class_name MainMenuUI

var _scenes = {
	sp_game = preload("res://Assets/UI/Pages/NewGameUI/NewGameUI.tscn"),
	load_game = preload("res://Assets/World/WorldDev.tscn"),
	help = preload("res://Assets/UI/Pages/HelpUI/HelpUI.tscn"),
	options = preload("res://Assets/UI/Pages/OptionsUI/OptionsUI.tscn"),
	exit = preload("res://Assets/UI/Pages/QuitGameUI/ExitScene.tscn")
}

func _input(event: InputEvent) -> void:
	if not event is InputEventKey and not event is InputEventMouseButton:
		return

	# Set the animation mark to the very end, so all final values are still set.
	var animation_player := $AnimationPlayer as AnimationPlayer
	animation_player.seek(animation_player.current_animation_length)

	accept_event() # Avoid triggering buttons on intro skip.
	set_process_input(false)

func _go_to_scene(scene: String) -> void:
	Audio.play_snd_click()

	if scene == "sp_game" or scene == "help" or scene == "options":
		var subscene = _scenes[scene].instantiate()
		subscene.parent = self
		visible = false
		get_tree().get_root().add_child(subscene)
	else:
		#warning-ignore:return_value_discarded
		get_tree().change_scene_to_packed(_scenes[scene])
