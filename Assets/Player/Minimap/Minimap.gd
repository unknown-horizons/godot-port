extends Control
class_name Minimap

var minimap_size: Vector2
var minimap_scale: Vector2
var terrain: GridMap
var terrain_tile_count: Vector2

# Scale is calculated here so it can be used to convert world position to minimap position.
func _ready():
	minimap_size = size
	terrain = get_tree().current_scene.get_node("AStarMap/Terrain") as GridMap

	var tile_min := Vector2.ZERO
	var tile_max := Vector2.ZERO

	if not terrain:
		return

	# Calculate gridmap size.
	# NOTICE: gridmap (world) size might be available somewhere.
	# Get terrain tile count along each axis.
	for tile in terrain.get_used_cells():
		var tile_index = tile as Vector3

		if tile_index.x > tile_max.x:
			tile_max.x = tile_index.x
		elif tile_index.x < tile_min.x:
			tile_min.x = tile_index.x

		if tile_index.z > tile_max.y:
			tile_max.y = tile_index.z
		elif tile_index.z < tile_min.y:
			tile_min.y = tile_index.z

	# Plus one at the end is required because
	# we need the count not the index.
	terrain_tile_count = (tile_max - tile_min) + Vector2.ONE

	# At this point gridmap (world) and minimap size are available so scale can be calculated.
	minimap_scale = minimap_size / terrain_tile_count

	# Draw each layer one by one.
	for layer in get_children():
		(layer as MinimapLayer).draw_layer()

# Converts world position to minimap position.
func world_to_minimap_position(world_position: Vector3) -> Vector2:
	var map_position := terrain.local_to_map(world_position)
	return Vector2(map_position.x, map_position.z)
