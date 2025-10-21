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

  var road_building_context = %GameContextManager.get_node("BuildingRoadContext")
  var road_pathfinding = %Pathfinding.road_pathfinding

  var size = building.get_oriented_size()
  for dy in range(size.y):
    for dx in range(size.x):
      var building_cell_tile_coords = building_tile_coords - Vector2i(dx, dy) # build up and left
      new_building_cells.append(building_cell_tile_coords)
      self.building_position_to_building[building_cell_tile_coords] = building
      building_all_cell_coords.append(building_cell_tile_coords)
      road_pathfinding.set_point_solid(building_cell_tile_coords, false)
      road_building_context.road_building_pathfindng.set_point_solid(building_cell_tile_coords, true)
  building.paused = false

  await get_tree().process_frame # wait for one frame, otherwise erase cells doesn't refresh the drawing if called from _on_child_entered_tree callstack
  for cell in building_all_cell_coords:
    if cell != building_tile_coords: # erase all other cells which the building covers
      self.set_cell(cell, -1)

  # handle notifications
  buildings_built.emit(building, new_building_cells)
  GameStats.game_stats_resource.resources_changed.emit() # trigger other buildings to look for resources again (including this building)

func _on_child_entered_tree(node: Node):
  if node is Building2D:
    register_building(node)

# debug layer:
@onready var tooltip_label: Label = self.get_node("/root/Main/DebugCanvasLayer/Control/BuiltTileMapLayerInfo") if not Engine.is_editor_hint() else null

var last_cell_coords: Vector2i = Vector2i(-999, -999)  # Init to invalid coords
func _unhandled_input(event):
  if event is InputEventMouseMotion:
    # var viewport = self.get_viewport()
    # var mouse_pos = viewport.get_mouse_position()
    # var local_mouse_pos1 = self.to_local(mouse_pos)
    # var local_mouse_pos2 = event.global_position
    # var gp1 = self.get_global_mouse_position()
    # var gp2 = event.global_position
    var local_mouse_pos = self.to_local(self.get_global_mouse_position())
    var cell_coords = self.local_to_map(local_mouse_pos)

    if cell_coords != last_cell_coords: # Avoid redundant updates
      last_cell_coords = cell_coords
      _update_tooltip(cell_coords)

func _update_tooltip(cell_coords: Vector2i):
  var atlas_coords = self.get_cell_atlas_coords(cell_coords)
  var cell_alternative_tile = self.get_cell_alternative_tile(cell_coords)
  # var tile_data = self.get_cell_tile_data(cell_coords)

  var building = self.building_position_to_building.get(cell_coords, null)
  self.tooltip_label.text = "Tile: %s\nAtlas: %s\ncell_alternative_tile: %s\nBuilding: %s" % [cell_coords, atlas_coords, cell_alternative_tile, building]
