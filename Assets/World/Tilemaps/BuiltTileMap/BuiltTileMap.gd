extends TileMapLayer

class_name BuiltTileMap

const is_tree: String = "is_tree"
const is_road: String = "is_road"

var building_name_to_cell_coords: Dictionary[String, Array] = {} # Dictionary[String, Array[Vector2i]] = {}. Nested types are not supported in Godot 4.5
var building_position_to_building: Dictionary[Vector2i, Building2D] = {}
var trees_getting_choped: Dictionary = {}

## emited when new buildings were built, usually one building at a time
signal buildings_built(building: Building2D, cells: Array[Vector2i])



func is_movable_on(cell: Vector2i) -> bool:
  var tile_data: TileData = self.get_cell_tile_data(cell)
  if tile_data != null:
    var terrain_name: String = self.tile_set.get_terrain_name(tile_data.terrain_set, tile_data.terrain)
    var is_road = terrain_name == "DirtRoad"
    return is_road
  return false

func get_trees() -> Array[Vector2i]:
  var trees: Array[Vector2i] = []
  for cell in self.get_used_cells():
    var cell_data = self.get_cell_tile_data(cell)
    if cell_data != null and cell_data.get_custom_data(is_tree):
      trees.append(cell)
  return trees

func register_building(building: Building2D) -> void:
  # register building to building poses
  var building_all_cell_coords = building_name_to_cell_coords.get(building.id, [])
  var building_tile_coords = self.local_to_map(building.position)
  var new_building_cells: Array[Vector2i] = []
  for dx in range(building.size.x):
    for dy in range(building.size.y):
      var building_cell_tile_coords = building_tile_coords + Vector2i(dx, dy)
      new_building_cells.append(building_cell_tile_coords)
      building_position_to_building[building_cell_tile_coords] = building
      building_all_cell_coords.append(building_cell_tile_coords)
      %Pathfinding.road_pathfinding.set_point_solid(building_cell_tile_coords, false)
      var road_building_context = %GameContextManager.get_node("BuildingRoadContext")
      road_building_context.road_building_pathfindng.set_point_solid(building_cell_tile_coords, true)
  building.paused = false
  # handle notifications
  buildings_built.emit(building, new_building_cells)

func _on_child_entered_tree(node: Node):
  if node is Building2D:
    register_building(node)
