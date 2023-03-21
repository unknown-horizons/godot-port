extends GridMap
class_name TileMap3D

## Tilemap in a 3D world.

func get_tile_at_mouse_position() -> Vector2:
	var raycast: Dictionary = get_viewport().get_camera_3d().get_parent().get_parent().raycast_from_mouse()

	var tile_pos: Vector2
	if raycast:
		var cell_pos := local_to_map(raycast.position)
		tile_pos = Utils.map_3_to_2(cell_pos)
	else:
		tile_pos = Vector2.ONE * -1

	return tile_pos

func set_tile(tile_pos: Vector2, tile_item: String = "") -> void:
	var tile_index = get_item_index(tile_item) if tile_item != "" else 0

	set_tile_item(tile_pos, tile_index)

func unset_tile(tile_pos: Vector2) -> void:
	set_tile_item(tile_pos, -1)

func get_tile_item(tile_pos: Vector2i) -> int:
	return get_cell_item(Vector3i(tile_pos.x,0,tile_pos.y))

func set_tile_item(tile_pos: Vector2, tile_index: int, item_orientation: int = 0) -> void:
	set_cell_item(Vector3(tile_pos.x, 0, tile_pos.y), tile_index, item_orientation)

func get_used_tiles() -> Array:
	var tiles := []
	for cell in get_used_cells():
		tiles.append(Utils.map_3i_to_2i(cell))

	return tiles

func get_used_tiles_by_item(item: int) -> Array:
	var tiles := []
	for tile in get_used_tiles():
		if get_tile_item(tile) == item:
			tiles.append(tile)

	return Array()

func get_tile_item_orientation(tile_pos: Vector2i) -> int:
	return get_cell_item_orientation(Vector3i(tile_pos.x,0,tile_pos.y))

func get_item_name(tile_item: int) -> String:
	return mesh_library.get_item_name(tile_item)

func get_item_index(item_name: String) -> int:
	return mesh_library.find_item_by_name(item_name)

# Returns the position of a tile cell in the TileMap3D's local coordinate space.
func tilemap_to_local(tile_pos: Vector2i) -> Vector2:
	return Utils.map_3_to_2(map_to_local(Vector3i(tile_pos.x,0,tile_pos.y)))

# Returns the coordinates of the tile cell containing the given point.
func world_to_tilemap(pos: Vector2) -> Vector2:
	var cell_pos := local_to_map(Utils.map_2_to_3(pos))
	return Utils.map_3_to_2(cell_pos)
