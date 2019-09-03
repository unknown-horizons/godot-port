extends Control

var parent = null

# Deactivate everything irrelevant for the time being
func _ready() -> void:
	var nodes = {
		"Scenario": null,
		"RandomMap": null,
		"AISlider": null,
		"ResourceDensitySlider": null,
		"Traders": null,
		"Disasters": null
	}

	nodes = find_nodes(get_tree().get_root(), nodes)
	prints("nodes", nodes)
	nodes["Scenario"].checkbox.disabled = true
	nodes["RandomMap"].checkbox.disabled = true
	nodes["AISlider"].editable = false
	nodes["ResourceDensitySlider"].editable = false
	nodes["Traders"].disabled = true
	nodes["Disasters"].disabled = true

func find_nodes(root_node: Node, nodes_to_be_found: Dictionary) -> Dictionary:
	for n in root_node.get_children():
		if n.get_child_count() > 0:
			find_nodes(n, nodes_to_be_found)

		if n.name in nodes_to_be_found:
			nodes_to_be_found[n.name] = n

	return nodes_to_be_found

func _on_BackToMenuButton_pressed() -> void:
	Audio.play_snd("click")
	parent.visible = true
	queue_free()

func _on_StartGameButton_pressed() -> void:
	if parent != null and Global.map:
		queue_free()
		#parent._go_to_scene("start_game")
		get_tree().change_scene_to(Global.map)
	else:
		Audio.play_snd("build")