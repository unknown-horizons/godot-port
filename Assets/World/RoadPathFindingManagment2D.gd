extends AStarGrid2D

class_name RoadPathFindingManagment2D

var tile_map_layer: TileMapLayer



func _init(used_tile_map_layer: TileMapLayer,
	default_compute_heuristic = self.HEURISTIC_MANHATTAN,
	cell_shape = self.CELL_SHAPE_ISOMETRIC_DOWN,
	diagonal_mode = self.DIAGONAL_MODE_NEVER):

	tile_map_layer = used_tile_map_layer
	setup_a_star(default_compute_heuristic, cell_shape, diagonal_mode)



func setup_a_star(default_compute_heuristic, cell_shape, diagonal_mode):
	
	self.default_compute_heuristic = default_compute_heuristic
	self.cell_shape = cell_shape
	self.diagonal_mode = diagonal_mode

	var used_rect = tile_map_layer.get_used_rect()
	self.region = Rect2i(used_rect.position - Vector2i(50,50), used_rect.size + Vector2i(100,100))
	self.cell_size = tile_map_layer.tile_set.tile_size

	self.update()
	self.fill_solid_region(self.region, true)

	for cell in tile_map_layer.get_used_cells():
		var tile_data = tile_map_layer.get_cell_tile_data(cell)
		if tile_data != null:
			self.set_point_solid(cell, not tile_data.get_custom_data("is_navigatable"))



func get_path_to_dest(start: Vector2, final_dest: Vector2):

	var grid_start = tile_map_layer.local_to_map(start - tile_map_layer.position)
	var grid_final_dest = tile_map_layer.local_to_map(final_dest - tile_map_layer.position)
	print(self.is_point_solid(grid_start), self.is_point_solid(grid_final_dest))
	var tile_map_layer_path = self.get_id_path(grid_start, grid_final_dest)
	var path = []
	for tile in tile_map_layer_path:
		path.append(tile_map_layer.map_to_local(tile))

	if len(path) > 0:
		return path
	else:
		return null
