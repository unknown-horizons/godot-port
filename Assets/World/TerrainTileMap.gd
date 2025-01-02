extends TileMapLayer

enum nav_types_int {
  road = 0
}

const nav_types_str = [
  "is_road_constructable",
]

signal build_tile_layer_build_road
signal set_solid_and_liquid_points
signal built_highlight_road

var is_road_building_started: bool = false
var road_start_pos: Vector2 = Vector2(0,0)
var last_mouse_tile_pos: Vector2i = Vector2(0,0)



func _ready():
  set_solid_and_liquid_points.emit(get_solid_and_liquid_points(), self.get_used_cells())



func _unhandled_input(event):
  if event is InputEventMouseButton:
    if event.pressed == true:
      if event.button_index == MOUSE_BUTTON_LEFT:
        check_and_respond()
      
      if event.button_index == MOUSE_BUTTON_MASK_RIGHT:
        is_road_building_started = false
        

  if event is InputEventMouseMotion:
    if is_road_building_started and BuildingManager.building_to_build == BuildingManager.road and last_mouse_tile_pos != self.local_to_map(self.get_global_mouse_position()):
      last_mouse_tile_pos = self.local_to_map(self.get_global_mouse_position())
      built_highlight_road.emit(road_start_pos, self.local_to_map(self.get_global_mouse_position()))



func get_solid_and_liquid_points():
  var solid_and_liquid_points: Dictionary = {"solid": {}, "liquid": {}}
  for cell in self.get_used_cells():
    if self.get_cell_tile_data(cell).get_custom_data(nav_types_str[nav_types_int.road]):
      solid_and_liquid_points.get("liquid")[cell] = null
    else:
      solid_and_liquid_points.get("solid")[cell] = null
  return solid_and_liquid_points



func check_and_respond():
  if BuildingManager.building_to_build == BuildingManager.road:
    if is_road_building_started:
      build_tile_layer_build_road.emit(road_start_pos, self.local_to_map(self.get_global_mouse_position()))

    else:
      road_start_pos = self.local_to_map(self.get_global_mouse_position())

    is_road_building_started = not is_road_building_started
