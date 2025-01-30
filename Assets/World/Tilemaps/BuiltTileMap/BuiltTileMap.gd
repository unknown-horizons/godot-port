extends TileMapLayer

class_name BuiltTileMap

const is_tree: String = "is_tree"
const is_road: String = "is_road"

var building_name_to_building_poses: Dictionary = {}
var building_position_to_building: Dictionary = {}
var trees_getting_choped: Dictionary = {}

func is_movable_on(cell: Vector2i) -> bool:
  var tile_data: TileData = self.get_cell_tile_data(cell)
  if tile_data != null:
    var terrain_name: String = self.tile_set.get_terrain_name(tile_data.terrain_set, tile_data.terrain)
    var is_road = terrain_name == "DirtRoad"
    return is_road
  return false

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

func register_building(building) -> void:
  # register building to building poses
  building_position_to_building[building.global_position] = building
  # register building pos into building array
  var building_poses = building_name_to_building_poses.get(building.building_data.game_name)
  if building_poses != null:
    building_poses.append(building.global_position)
  else:
    building_name_to_building_poses[building.building_data.game_name] = [building.position]
  # set points for pathfinding
  %Pathfinding.carrier_pathfinding.set_point_solid(self.local_to_map(building.position), false)
  var road_building_context = %GameContextManager.get_node("BuildingRoadContext")
  road_building_context.road_building_pathfindng.set_point_solid(self.local_to_map(building.position), true)
  # handle notifications
  for building_node: Building2D in building_position_to_building.values():
    if building_node.has_method("new_building_built"):
      building_node.new_building_built(building)

func _on_child_entered_tree(node: Node):
  if node is Building2D:
    register_building(node)
