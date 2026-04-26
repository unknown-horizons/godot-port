extends Control
class_name MainMenuUI

var _scenes: Dictionary = {
	sp_game = preload("res://Assets/UI/Pages/NewGameUI/NewGameUI.tscn"),
	# load_game = preload("res://Assets/World/WorldDev.tscn"),
	load_game = preload("res://Assets/World/WorldDev2D.tscn"),
	help = preload("res://Assets/UI/Pages/HelpUI/HelpUI.tscn"),
	options = preload("res://Assets/UI/Pages/OptionsUI/OptionsUI.tscn"),
	exit = preload("res://Assets/UI/Pages/QuitGameUI/ExitScene.tscn"),
}

func _ready() -> void:
	if PlatformPolicy.should_hide_application_quit_controls():
		var quit_btn: Node = find_child("QuitButton", true, false)
		if quit_btn != null:
			quit_btn.queue_free()

func _input(event: InputEvent) -> void:
	if not event is InputEventKey and not event is InputEventMouseButton:
		return

	# Set the animation mark to the very end, so all final values are still set.
	var animation_player := $AnimationPlayer as AnimationPlayer
	animation_player.seek(animation_player.current_animation_length)

	accept_event() # Avoid triggering buttons on intro skip.
	set_process_input(false)

func _on_quit_requested() -> void:
	Audio.play_snd_click()
	if PlatformPolicy.should_hide_application_quit_controls():
		return
	Notice230ConfirmModal.present(
		get_tree(),
		Notice230ConfirmModal.QUIT_CONFIRM_TITLE,
		Notice230ConfirmModal.QUIT_CONFIRM_MESSAGE,
		Callable(self, "_quit_after_confirm"),
	)

func _quit_after_confirm() -> void:
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to_packed(_scenes.exit)

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
