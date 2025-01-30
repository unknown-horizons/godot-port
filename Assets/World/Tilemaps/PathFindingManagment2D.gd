extends AStarGrid2D

class_name PathFindingManagement2D

var tile_map_layer: TileMapLayer
var straight_first: bool


func _init(used_tile_map_layer: TileMapLayer,
  straight_first_mode := true,
  diagonal_mode := self.DIAGONAL_MODE_NEVER,
  default_compute_heuristic := self.HEURISTIC_MANHATTAN,
    cell_shape := self.CELL_SHAPE_ISOMETRIC_DOWN):
  tile_map_layer = used_tile_map_layer
  setup_a_star(straight_first_mode, diagonal_mode, default_compute_heuristic, cell_shape)

func setup_a_star(straight_first_mode, diagonal_mode, default_compute_heuristic, cell_shape):
  straight_first = straight_first_mode
  self.default_compute_heuristic = default_compute_heuristic
  self.cell_shape = cell_shape
  self.diagonal_mode = diagonal_mode
  update_region()
  self.cell_size = tile_map_layer.tile_set.tile_size
  self.update()
  self.fill_solid_region(self.region, true)
  # set the cost high to then lower it on preferable path
  self.fill_weight_scale_region(self.region, 1000)

func update_region():
  #var used_rect = tile_map_layer.get_used_rect()
  var used_rect = Rect2i(-1000, -1000, 2000, 2000)
  self.region = Rect2i(used_rect.position - Vector2i(50,50), used_rect.size + Vector2i(100,100))
  self.update()

func set_points_passable(cells: Array, passable: bool = true):
  for cell in cells:
    self.set_point_solid(cell, not passable)

func set_points(cells, is_passable_func: Callable):
  for cell in cells:
    self.set_point_solid(cell, not is_passable_func.call(cell))

func get_ideal_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
  var path: Array[Vector2i] = []
  var x1 = min(from.x, to.x)
  var x2 = max(from.x, to.x)
  var y1 = min(from.y, to.y)
  var y2 = max(from.y, to.y)
  for x in range(x1, x2+1):
    path.append(Vector2i(x,y1))
    path.append(Vector2i(x,y2))
  for y in range(y1, y2+1):
    path.append(Vector2i(x1,y))
    path.append(Vector2i(x2,y))
  return path

func set_points_weight(points: Array[Vector2i], weight: float = 1) -> void:
  for cell in points:
    self.set_point_weight_scale(cell, weight)

func get_path_to_dest(start: Vector2, final_dest: Vector2, in_grid: bool = false, get_back_in_grid: bool = false):
  var grid_start
  var grid_final_dest
  if not in_grid:
    grid_start = tile_map_layer.local_to_map(start - tile_map_layer.position)
    grid_final_dest = tile_map_layer.local_to_map(final_dest - tile_map_layer.position)
  else:
    grid_start = start
    grid_final_dest = final_dest
  #if prefered straight path set preferable path points to lower weight(one less than usual)
  var ideal_path: Array[Vector2i] = []
  if straight_first:
    ideal_path = get_ideal_path(grid_start, grid_final_dest)
    set_points_weight(ideal_path, 999)
  # get path and convert to correct system (world or grid)
  var tile_map_layer_path = self.get_id_path(grid_start, grid_final_dest)
  var path: Array = []
  if not get_back_in_grid:
    for tile in tile_map_layer_path:
      path.append(tile_map_layer.map_to_local(tile))
  else:
    path = tile_map_layer_path
  # set point weight back to normal
  if straight_first:
    set_points_weight(ideal_path, 1000)
  if len(path) > 0:
    return path
  else:
    return null
