tool
extends BookMenu
class_name NewGameUI

onready var player_name := find_node("PlayerName") as LineEditEx

func _ready() -> void:
	# Deactivate everything irrelevant for the time being
	var nodes = {
		"Scenario": null,
		"RandomMap": null,
		"ResourceDensitySlider": null,
		"Disasters": null,
	}

	find_nodes(get_tree().get_root(), nodes)
	nodes["Scenario"].check_box.disabled = true
	nodes["RandomMap"].check_box.disabled = true
	nodes["ResourceDensitySlider"].editable = false
	nodes["Disasters"].disabled = true

	player_name.text = Config.player_name

func find_nodes(root_node: Node, nodes_to_be_found: Dictionary) -> void:
	for n in root_node.get_children():
		if n.get_child_count() > 0:
			find_nodes(n, nodes_to_be_found)

		if n.name in nodes_to_be_found:
			nodes_to_be_found[n.name] = n

func _on_CancelButton_pressed() -> void:
	._on_CancelButton_pressed()

func _on_OKButton_pressed() -> void:
	if Global.map:
		queue_free()
		#warning-ignore:return_value_discarded
		get_tree().change_scene_to(Global.map)
	else:
		Audio.play_snd("build")
