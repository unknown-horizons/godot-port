@tool
extends EditorScript

var nodes := []

func _run() -> void:
	var root_node := get_scene()

	if root_node.name in ["TrailMeshes", "GravelPathMeshes", "StonePathMeshes"] and root_node.get_class() == "Node3D":
		_clean_up_scene_tree()

		nodes = root_node.get_children()
		_create_sub_nodes_with_suffix("green")
		_create_sub_nodes_with_suffix("red")

func _clean_up_scene_tree() -> void:
	print("Tidy up nodes")
	for node in get_scene().get_children():
		if node.name.split("-", false, 1).size() > 1:
			node.free()

func _create_sub_nodes_with_suffix(node_suffix: String) -> void:
	var root_node := get_scene()
	var color := {"green": Color.GREEN, "red": Color.RED}

	for node in nodes:
		var copy = node.duplicate()
		copy.name = copy.name + "-" + node_suffix

		var mesh = node.mesh.duplicate()
		var material = mesh.material.duplicate()

		material.albedo_color = color[node_suffix]
		mesh.material = material
		copy.mesh = mesh

		prints("Adding node", node.name)
		root_node.add_child(copy)
		copy.owner = root_node
