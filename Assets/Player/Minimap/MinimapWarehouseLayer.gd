extends MinimapLayer
class_name MinimapWarehouseLayer

@export var warehouse_icon: Texture2D
@export var warehouse_icon_scale: Vector2

var warehouses: Array
var minimap: Minimap

func _draw():
	if minimap == null:
		return

	for warehouse in warehouses:
		draw_set_transform(warehouse,
			-minimap.get_rotation(),
			warehouse_icon_scale)
		draw_texture(warehouse_icon,
			warehouse_icon.get_size() * warehouse_icon_scale / -2)

func draw_layer():
	minimap = get_parent() as Minimap
	var buildings_node : Node3D = get_tree().current_scene.get_node("Buildings")

	# Create an array of warehouse locations.
	for player in buildings_node.get_children():
		for building in player.get_children():
			if building is Warehouse:
				warehouses.append(
					minimap.world_to_minimap_position(
						building.global_transform.origin))

	queue_redraw()
