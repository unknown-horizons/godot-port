extends BaseContext

class_name BuildingRoadContext

@onready var terrain_tilemap: TerrainTileMap = %TerrainTileMap
@onready var built_tilemap: BuiltTileMap = %BuiltTileMap
@onready var road_highlighter: TileMapLayer = %RoadHighlighter

## pathfinding for road building
@onready var road_building_pathfindng = PathFindingManagement2D.new(%BuiltTileMap)

var is_road_building_started: bool = false
var road_start_tile_position: Vector2i = Vector2i(0,0)
var last_mouse_tile_position: Vector2i = Vector2i(0,0)

func _ready():
  # setup the road building pathfinding
  var terrain_points = terrain_tilemap.get_terrain_points()
  var land = terrain_points["Grass"].keys().duplicate()
  land.append_array(terrain_points["Beach"].keys().duplicate())
  road_building_pathfindng.set_points_passable(land, true)

func _unhandled_input(event):
  if event.is_action_pressed("toggle_build_road"):
    %GameContextManager.current_context = self

  if self.is_active:
    if event is InputEventMouseButton:
      if event.pressed == true:
        if event.button_index == MOUSE_BUTTON_LEFT:
          respond_to_left_click()
        
        if event.button_index == MOUSE_BUTTON_RIGHT:
          if not is_road_building_started:
            %GameContextManager.current_context = null
          else:
            self.is_road_building_started = false
            road_highlighter.clear()
  
    if event is InputEventMouseMotion and is_road_building_started:
      highlight_road()

func respond_to_left_click() -> void:
  if is_road_building_started:
    build_road()
  else:
    road_start_tile_position = terrain_tilemap.local_to_map(terrain_tilemap.get_global_mouse_position())
  is_road_building_started = not is_road_building_started

func highlight_road() -> void:
  var tile_mouse_position: Vector2i = terrain_tilemap.local_to_map(terrain_tilemap.get_global_mouse_position())
  # check if mouse is not on the same tile as last time
  if last_mouse_tile_position != tile_mouse_position and is_road_building_started:
    last_mouse_tile_position = tile_mouse_position
    var path = road_building_pathfindng.get_path_to_dest(road_start_tile_position, last_mouse_tile_position, true, true)
    road_highlighter.clear()
    if path != null:
      road_highlighter.set_cells_terrain_connect(path, 0, 0, false)

func build_road() -> void:
  road_highlighter.clear()
  # check if there is a building on the start positionition
  var scene_in_start_point = built_tilemap.building_position_to_building.find_key(built_tilemap.map_to_local(road_start_tile_position))
  if scene_in_start_point != null:
    return

  ## finish tile of the road
  var finish_tile_point = built_tilemap.local_to_map(built_tilemap.get_global_mouse_position())
  var path = road_building_pathfindng.get_path_to_dest(road_start_tile_position, finish_tile_point, true, true)
  if path != null:
    built_tilemap.set_cells_terrain_connect(path, 0, 0, false)
  # delete all the trees below the road that might be blocking the view
    for cell in path:
      var lower_tile_position = cell + Vector2i(1, 1) # right one and down one
      var lower_tile_data = built_tilemap.get_cell_tile_data(lower_tile_position)
      if lower_tile_data != null and lower_tile_data.get_custom_data(built_tilemap.is_tree):
        built_tilemap.set_cell(lower_tile_position, -1)

    %Pathfinding.carrier_pathfinding.set_points_passable(path, true)
    # handle notifications
    for building_node in built_tilemap.building_position_to_building.values():
      if building_node.has_method("road_built"):
        building_node.road_built()
