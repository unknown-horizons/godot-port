extends TileMapLayer

var astar_grid = RoadPathFindingManagment2D.new(self)


var building_name_to_building_poses: Dictionary = {}
var building_pos_to_building: Dictionary = {}

signal new_building_builded



func _unhandled_input(event):
  if event is InputEventMouseButton:
    if event.pressed == true:
      if event.button_index == MOUSE_BUTTON_LEFT:
        check_and_build()


      if event.button_index == MOUSE_BUTTON_RIGHT:
        BuildingManager.building_to_build == null
        return



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
    #new_building_builded.emit(building.position)
    new_building_builded.emit(building)
    if building is ProductionBuilding2D:
      new_building_builded.connect(building.new_building_builded)



func get_path_to_dest(start: Vector2, final_dest: Vector2):
  return astar_grid.get_path_to_dest(start, final_dest)



func get_id(building_to_build):
# note: to be replaced
  var building_id
  if building_to_build == "Farm":
    building_id = 1
  if building_to_build == "WareHouse":
    building_id = 2
  
  return building_id



func check_and_build():
  var grid_building_pos = self.local_to_map(self.get_global_mouse_position() - self.position)
  var world_building_pos = self.map_to_local(grid_building_pos)

  var building_to_build = get_building_to_build(world_building_pos)


  if building_to_build != null:

    var tile_id = get_id(building_to_build)
    if tile_id != null:

      astar_grid.set_point_solid(grid_building_pos, false)
      self.set_cell(grid_building_pos, 0, Vector2i(0, 0), tile_id)
