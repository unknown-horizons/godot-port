extends BaseContext
## The BuildingContext is responsible for building buildings.

class_name BuildingContext

## The shader used to highlight buildings when in building mode
@export var building_shader: ShaderMaterial = preload("res://Assets/World/Tilemaps/Highlight/BuildingHighlight.tres")

@onready var object_selected_context: ObjectSelectedContext = self.get_node("/root/Main/GameContextManager/ObjectSelectedContext")
@onready var terrain_tilemap: TerrainTileMap = %TerrainTileMap
@onready var built_tilemap: BuiltTileMap = %BuiltTileMap
@onready var highlighter: RoadAndBuildingHighlighter = %RoadAndBuildingHighlighter

## The building to build.
## Note: The context will become active and reset the reference object if the property is set.
var building_to_build: BuildingData = null:
  get:
    return building_to_build
  set(value):
    building_to_build = value
    reference_object = null
    update_building_highlight()
    if not self.is_active:
      self.game_context_manager.current_context = self

## The object that is used as a reference for the building placement and other things.
## If a additional check for valid building tile is desired, the object must have a function, "is_tile_valid_for_building(building_tile_position)".
var reference_object: WorldThing2D = null

var last_highlighted_building_position: Vector2i

# clear the highlights
func context_exited() -> void:
  super()
  highlighter.clear()

func _unhandled_input(event: InputEvent) -> void:
  var build_building_data: BuildingData

  if event.is_action_pressed("toggle_build_building"):
    build_building_data = event.get_meta("building_data")
    if build_building_data == null:
      push_error("`toggle_build_building` action is pressed, but `building_name` meta is null or empty.")

  if build_building_data:
    # print_debug(event, ", building_data: ", build_building_data);
    if (build_building_data != null):
      building_to_build = build_building_data
      return
  
  if self.is_active:
    if event is InputEventMouseButton:
      if event.pressed == true:
        if event.button_index == MOUSE_BUTTON_LEFT:
          build()
        
        if event.button_index == MOUSE_BUTTON_RIGHT:
          if reference_object != null:
            # find the selectable
            var selectable: Selectable
            for node in reference_object.get_children():
              if node is Selectable:
                selectable = node
                break
            if selectable != null: # if a selectable was found then set it as selected
              self.game_context_manager.current_context = object_selected_context
              object_selected_context.set_selected_objects([selectable])
              return
          self.game_context_manager.current_context = null # if cannot get the selectable of the reference object then set the context to null

func _process(_delta):
  if self.is_active:
    update_building_highlight()

func can_build_building(building_world_position: Vector2 = built_tilemap.to_local(built_tilemap.get_global_mouse_position()), building: BuildingData = building_to_build) -> bool:
  if building == null:
    return false
  var building_tile_position = built_tilemap.local_to_map(building_world_position)
  building_world_position = built_tilemap.map_to_local(building_tile_position) # center out the world position by tile
  
  ## check if the reference object says that the tile is valid
  if reference_object != null and reference_object.has_method("is_tile_valid_for_building"):
    if reference_object.is_tile_valid_for_building(building_tile_position) == false:
      return false
  
  # check if the tile is valid on the built_tilemap
  var is_road: bool = false
  var built_tile_data: TileData = built_tilemap.get_cell_tile_data(building_tile_position)
  if built_tile_data != null: # if the built_tile_data is null, then it is not a road
    var built_terrain_name: String = built_tilemap.tile_set.get_terrain_name(built_tile_data.terrain_set, built_tile_data.terrain)# The terrain name of the tile.
    is_road = built_terrain_name == "DirtRoad" # Is the tile a road?
  var is_building: bool = built_tilemap.building_position_to_building.has(building_world_position)# Is the tile a building?
  if is_road or is_building:# If it is a road or a building, then the tile not valid
    return false
  
  # make sure that the terrain tile is valid
  var terrain_tile_data: TileData = terrain_tilemap.get_cell_tile_data(building_tile_position)
  var terrain_name: String = terrain_tilemap.tile_set.get_terrain_name(terrain_tile_data.terrain_set, terrain_tile_data.terrain)
  if terrain_name == "Shallow" or terrain_name == "Deep":
    return false
  
  # make sure that there is enough resources
  if has_resources_for_building(building) == false:
    return false
  
  return true

func update_building_highlight(building_tile_position: Vector2i = built_tilemap.local_to_map(built_tilemap.to_local(built_tilemap.get_global_mouse_position()))) -> void:
  var building_instance: Building2D = null
  if building_tile_position != last_highlighted_building_position or len(highlighter.highlighted_objects) == 0: # if the mouse moved or there is no highlighted building, then update the highlighter
    last_highlighted_building_position = building_tile_position # update the last highlighted building position
    highlighter.clear() # clear the highlighter
    highlighter.set_cell(building_tile_position, 0, Vector2i.ZERO, building_to_build.building_tile) # add the building highlight
    building_instance = await highlighter.new_building_added # wait for the building highlight to be added
    building_instance.highlight_shader = building_shader

  elif building_instance == null: # The highlighted_objects is not empty becouse the previous if statement would be entered and set the building_instance
    building_instance = highlighter.highlighted_objects[0]
  # now that the building instance is not null, highlight is updated, and the shader is set, set the shader to correct color
  building_instance.highlight_shader.set_shader_parameter("can_build", can_build_building(built_tilemap.map_to_local(building_tile_position)))
  building_instance.is_highlight = true

func has_resources_for_building(building_data: BuildingData = building_to_build) -> bool:
  for resource: ItemData in building_data.cost.keys():
    var amount_needed: int = building_data.cost[resource]
    var amount_available = GameStats.game_stats_resource.resources.get(resource)
    var can_be_built: bool = amount_available != null and amount_needed <= amount_available
    if not can_be_built:
      # in the future, tell the player the needed resources
      return false
  return true

func spend_resources_for_building(building_data: BuildingData = building_to_build) -> void:
  for resource: ItemData in building_data.cost.keys():
    var amount_needed: int = building_data.cost[resource]
    GameStats.game_stats_resource.resources[resource] -= amount_needed
    print("the amount of %s is now %s" % [resource.game_name, GameStats.game_stats_resource.resources[resource]])

func build(building_world_position: Vector2 = built_tilemap.to_local(built_tilemap.get_global_mouse_position())) -> void:
  ## The tile position of the new building
  var building_tile_position = built_tilemap.local_to_map(building_world_position)
  building_world_position = built_tilemap.map_to_local(building_tile_position) # The centered position of the new building
  if building_to_build != null and can_build_building(building_world_position): # If there is a building to build and it can be built
    spend_resources_for_building()
    built_tilemap.set_cell(building_tile_position, 0, Vector2i.ZERO, building_to_build.building_tile)
    highlighter.clear()
