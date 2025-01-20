extends TileMapLayer

class_name TerrainTileMap

enum nav_types_int {
  road = 0
}

const nav_types_str = [
  "is_road_constructable",
]

signal build_tile_layer_build_road
signal set_land_and_water_points
signal built_highlight_road

var ship_pathfinding: PathFindingManagement2D = PathFindingManagement2D.new(self,
  false,
  AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE,
  AStarGrid2D.HEURISTIC_MANHATTAN,
  AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN)

var is_road_building_started: bool = false
var road_start_pos: Vector2 = Vector2(0,0)
var last_mouse_tile_pos: Vector2i = Vector2(0,0)



func _ready():
  var terrain_points = get_terrain_points()
  var water_points: Array = terrain_points["Deep"].keys().duplicate()
  water_points.append_array(terrain_points["Shallow"].keys().duplicate())
  ship_pathfinding.set_points_passable(water_points, true)
  # convert to solid and liquid keys to emit in expected format
  var land: Dictionary = terrain_points["Grass"].duplicate()
  land.merge(terrain_points["Beach"].duplicate())
  var water: Dictionary = terrain_points["Shallow"].duplicate()
  water.merge(terrain_points["Deep"].duplicate())
  var land_and_water_points: Dictionary = {"water": water, "land": land}
  set_land_and_water_points.emit(land_and_water_points, self.get_used_cells())

func _unhandled_input(event):
  if event is InputEventMouseButton:
    if event.pressed == true:
      if event.button_index == MOUSE_BUTTON_LEFT:
        check_and_respond()
  
      if event.button_index == MOUSE_BUTTON_MASK_RIGHT:
        is_road_building_started = false
  
  if event is InputEventMouseMotion:
    if BuildingManager.building_to_build != null and BuildingManager.building_to_build.game_name == "road":
      if  is_road_building_started and last_mouse_tile_pos != self.local_to_map(self.get_global_mouse_position()):
        last_mouse_tile_pos = self.local_to_map(self.get_global_mouse_position())
        built_highlight_road.emit(road_start_pos, self.local_to_map(self.get_global_mouse_position()))

func get_terrain_points() -> Dictionary:
  var terrain_points: Dictionary = {"Grass": {}, "Beach": {}, "Shallow": {}, "Deep": {}}
  for cell in self.get_used_cells():
    self.get_cell_tile_data(cell)
    var tile_data: TileData = self.get_cell_tile_data(cell)
    if tile_data != null and tile_data.terrain != null:
      terrain_points.get(self.tile_set.get_terrain_name(tile_data.terrain_set, tile_data.terrain))[cell] = null
  return terrain_points

func check_and_respond():
  if BuildingManager.building_to_build != null and BuildingManager.building_to_build.game_name == "road":
    if is_road_building_started:
      build_tile_layer_build_road.emit(road_start_pos, self.local_to_map(self.get_global_mouse_position()))

    else:
      road_start_pos = self.local_to_map(self.get_global_mouse_position())

    is_road_building_started = not is_road_building_started
