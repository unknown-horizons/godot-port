extends SceneTileMapLayer

class_name TileMapLayerNavigation

enum Buildings {
  farm =            1,
  warehouse =       2,
  cattle_run =      3,
  lumberjack_tent = 4,
  #lumberjack_hut =  5,
}


const is_navigatable: String = "is_navigatable"
const is_tree: String = "is_tree"

var person_pathfinding = PathFindingManagment2D.new(self)
var road_building_pathfindng = PathFindingManagment2D.new(self)
#var forester_pathfinding = PathFindingManagment2D.new(self)

var building_name_to_building_poses: Dictionary = {}
var building_pos_to_building: Dictionary = {}
var trees_getting_choped: Dictionary = {}

var terrain_points: Dictionary = {}

#enum cell_ids {
  #road = 2
#}

signal new_building_built
signal road_built
signal highlighter_highlight_road



func _ready():
  person_pathfinding.set_points(self.get_used_cells(), is_movable_on)
  #forester_pathfinding.set_points_passable(get_trees(), false)



func _unhandled_input(event):
  if event is InputEventMouseButton:
    if event.pressed == true:
      if event.button_index == MOUSE_BUTTON_LEFT:
        check_and_build()


      if event.button_index == MOUSE_BUTTON_RIGHT:
        BuildingManager.building_to_build = null
        highlighter_highlight_road.emit([], false)
        #return



func highlight_road(start, end):
  if self.building_pos_to_building.has(self.map_to_local(start)):
    return
  var path = road_building_pathfindng.get_path_to_dest(start, end, true, true)
  if path != null:
    highlighter_highlight_road.emit(path, true)
  else:
    highlighter_highlight_road.emit([], false)



func get_trees(in_grid: bool = true) -> Array[Vector2]:
  var trees: Array[Vector2] = []
  for cell in self.get_used_cells():
    var cell_data = self.get_cell_tile_data(cell)
    if cell_data != null and cell_data.get_custom_data(is_tree):
      if in_grid:
        trees.append(cell)
      else:
        trees.append(self.map_to_local(cell))
  return trees



#func is_cell_tree(cell_world_pos):
  #var cell_data = self.get_cell_tile_data(self.local_to_map(cell_world_pos))  #if tree_cell_data != null:
    ##if tree_cell_data.get_custom_data(is_tree):
      ##return true
  ##else:
    ##return false
  #return cell_data != null and cell_data.get_custom_data(is_tree)



func is_road_buildable_on(cell):
  var is_allowed_by_terrain: bool = terrain_points.get("liquid").has(cell)
  var is_oqupied: bool = building_pos_to_building.has(cell) #and self.get_cell_tile_data(cell).get_custom_data("is_navigatable")
  var can_build: bool = is_allowed_by_terrain and not is_oqupied
  #print(cell, is_allowed_by_terrain and not is_oqupied)
  #if not can_build:
    #print(cell, false)
  return can_build



func is_movable_on(cell):
  #print(self.get_cell_tile_data(cell).get_custom_data("is_navigatable"))
  return self.get_cell_tile_data(cell).get_custom_data(is_navigatable)



func get_building_to_build(pos):
  if BuildingManager.building_to_build != null:

# check if space is ocupied
    if building_pos_to_building.has(pos):  return null
    else:  return BuildingManager.building_to_build

  else: return null



func register_building(building):
  if building != null:
# register building to building poses
    building_pos_to_building[building.position] = building

# register building pos into building array
    var building_poses = building_name_to_building_poses.get(building.game_name)
    if building_poses != null:
      building_poses.append(building.position)
    else:
      building_name_to_building_poses[building.game_name] = [building.position]

# handle signals
    #new_building_built.emit(building.position)
    new_building_built.emit(building)
    if building is ProductionBuilding2D:
      new_building_built.connect(building.new_building_built)
      road_built.connect(building.road_built)



func get_path_to_dest(start: Vector2, final_dest: Vector2, in_grid: bool = false, get_back_in_grid: bool = false):
  return person_pathfinding.get_path_to_dest(start, final_dest, in_grid, get_back_in_grid)




func check_and_build():
  if BuildingManager.building_to_build == BuildingManager.road:
    return

  var grid_building_pos = self.local_to_map(self.get_global_mouse_position() - self.position)
  var world_building_pos = self.map_to_local(grid_building_pos)
  var cell_custom_data = self.get_cell_tile_data(grid_building_pos)
  var is_tile_tree = false

  if cell_custom_data != null:
    is_tile_tree = cell_custom_data.get_custom_data(is_tree)
  var is_empty = self.get_cell_source_id(grid_building_pos) == -1
  if not is_empty and not is_tile_tree:
    return

  var building_to_build = get_building_to_build(world_building_pos)
  if building_to_build != null:
    if terrain_points.get("solid").has(grid_building_pos):
      return
    var tile_id = Buildings.get(building_to_build)
    if tile_id != null:
      if BuildingManager.has_resources_for_building():
        person_pathfinding.set_point_solid(grid_building_pos, false)
        road_building_pathfindng.set_point_solid(grid_building_pos, true)
        BuildingManager.spend_resources_for_building()
        self.set_scene(grid_building_pos, 0, Vector2i(0, 0), tile_id)



func set_road_building_terrain_points(points: Dictionary, used_cells: Array):
  terrain_points = points
  road_building_pathfindng.set_points(used_cells, is_road_buildable_on)



func build_road(start_point: Vector2, finish_point: Vector2i):
  highlighter_highlight_road.emit([], false)
  if self.building_pos_to_building.has(self.map_to_local(start_point)):
    return
  var path = road_building_pathfindng.get_path_to_dest(start_point, finish_point, true, true)
  if path != null:
    self.set_cells_terrain_connect(path, 0, 0, false)

# delete all the trees below the road that might be blocking the view
    for cell in path:
      var lower_tile_pos = cell + Vector2i(1, 1) # right one and down one
      var lower_tile_data = self.get_cell_tile_data(lower_tile_pos)
      if lower_tile_data != null and lower_tile_data.get_custom_data(is_tree):
        self.set_cell(lower_tile_pos, -1)

    person_pathfinding.set_points_passable(path, true)
    road_built.emit()
  #for cell in road_building_pathfindng.get_path_to_dest(start_point, finish_point, true):
    #self.set_cell(cell, )
