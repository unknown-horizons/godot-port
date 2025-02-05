extends BaseContext
## The BuildingContext is responsible for building buildings.

class_name BuildingContext

## set the "key: value" as "name: BuildingData"
@export var building_data: Dictionary = {}

@onready var terrain_tilemap: TerrainTileMap = %TerrainTileMap
@onready var built_tilemap: BuiltTileMap = %BuiltTileMap

var building_to_build: BuildingData = null

func _ready():
  for building_data_name in building_data.keys():
    if building_data_name != building_data[building_data_name].game_name:
      push_error("building_data key: %s is not the same as the game_name: %s" % [building_data_name, building_data[building_data_name].game_name])

func _unhandled_input(event: InputEvent) -> void:
  var build_building_name := ""

  if event.is_action_pressed("toggle_build_building"):
    build_building_name = event.get_meta("building_name")
    if build_building_name == null or build_building_name== "":
      push_error("`toggle_build_building` action is pressed, but `building_name` meta is null or empty.")

  if build_building_name:
    print_debug(event, ", building_name: ", build_building_name);
    if (build_building_name != null):
      set_building_to_build(build_building_name)
      return
  
  if self.is_active:
    if event is InputEventMouseButton:
      if event.pressed == true:
        if event.button_index == MOUSE_BUTTON_LEFT:
          build()

        if event.button_index == MOUSE_BUTTON_RIGHT:
          building_to_build = null
          self.game_context_manager.current_context = null

func set_building_to_build(building_name: String):
  building_to_build = building_data.get(building_name)
  if not self.is_active:
    self.game_context_manager.current_context = self

func has_resources_for_building(prod_building_data: BuildingData = building_to_build) -> bool:
  for resource: ItemData in prod_building_data.cost.keys():
    var amount_needed: int = prod_building_data.cost[resource]
    var amount_available = GameStats.game_stats_resource.resources.get(resource)
    var can_be_built: bool = amount_available != null and amount_needed <= amount_available
    if not can_be_built:
      # in the future, tell the player the needed resources
      return false

  return true

func spend_resources_for_building(prod_building_data: BuildingData = building_to_build) -> void:
  for resource: ItemData in prod_building_data.cost.keys():
    var amount_needed: int = prod_building_data.cost[resource]
    GameStats.game_stats_resource.resources[resource] -= amount_needed
    print("the amount of %s is now %s" % [resource.game_name, GameStats.game_stats_resource.resources[resource]])

func build() -> void:
  var tile_building_pos = built_tilemap.local_to_map(built_tilemap.get_global_mouse_position() - built_tilemap.position)
  var world_building_pos = built_tilemap.map_to_local(tile_building_pos)
  # check if the tile is valid on the built_tilemap
  var built_tile_data: TileData = built_tilemap.get_cell_tile_data(tile_building_pos)
  if built_tile_data != null: # if the built_tile_data is null, then the tile is valid
    var built_terrain_name: String = built_tilemap.tile_set.get_terrain_name(built_tile_data.terrain_set, built_tile_data.terrain)
    var is_road: bool = built_terrain_name == "DirtRoad"
    var is_building: bool = built_tilemap.building_position_to_building.has(world_building_pos)
    if is_road or is_building:
      return
  # make sure that the terrain tile is valid
  var terrain_tile_data: TileData = terrain_tilemap.get_cell_tile_data(tile_building_pos)
  var terrain_name: String = terrain_tilemap.tile_set.get_terrain_name(terrain_tile_data.terrain_set, terrain_tile_data.terrain)
  if terrain_name == "Shallow" or terrain_name == "Deep":
    return
  if building_to_build != null:
    var tile_id = building_to_build.building_tile
    if tile_id != null:
      if has_resources_for_building():
        spend_resources_for_building()
        built_tilemap.set_cell(tile_building_pos, 0, Vector2i(0, 0), tile_id)
