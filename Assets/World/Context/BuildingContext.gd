extends BaseContext
## The BuildingContext is responsible for building buildings.

class_name BuildingContext

@onready var object_selected_context: ObjectSelectedContext = self.get_node("/root/Main/GameContextManager/ObjectSelectedContext") if not Engine.is_editor_hint() else null
@onready var terrain_tilemap: TerrainTileMap = %TerrainTileMap
@onready var built_tilemap: BuiltTileMap = %BuiltTileMap
@onready var highlighter: RoadAndBuildingHighlighter = %RoadAndBuildingHighlighter

## The building to build.
## Note: The context will become active and reset the reference object if the property is set.
var building_to_build: StringName = BuildingConfig.Buildings.NONE:
  get:
    return building_to_build
  set(value):
    building_to_build = value
    reference_object = null
    var building_cell_coords = built_tilemap.local_to_map(built_tilemap.to_local(built_tilemap.get_global_mouse_position()))
    update_building_highlight(building_cell_coords)
    if not self.is_active:
      self.game_context_manager.current_context = self

var building_size: Vector2i

## The object that is used as a reference for the building placement and other things.
## If a additional check for valid building tile is desired, the object must have a function, "is_tile_valid_for_building(building_tile_position)".
var reference_object: WorldThing2D = null

var last_highlighted_building_position: Vector2i

# clear the highlights
func context_exited() -> void:
  super()
  highlighter.clear()

func pascal_to_upper_snake_case(text: String) -> String:
  var regex := RegEx.new()
  regex.compile(r"([a-z])([A-Z])")  # match lowercase followed by uppercase
  var result := regex.sub(text, r"$1_$2", true)
  return result.to_upper()

func _unhandled_input(event: InputEvent) -> void:
  var build_building_data: StringName = BuildingConfig.Buildings.NONE

  if event.is_action_pressed("toggle_build_building"):
    build_building_data = event.get_meta("button_name").replace("Build", "").replace("Button", "")
    build_building_data = pascal_to_upper_snake_case(build_building_data)
    if build_building_data == null:
      push_error("`toggle_build_building` action is pressed, but `building_name` meta is null or empty.")

  if not BuildingConfig.building_to_cost.has(build_building_data):
    push_error("The building name %s does not have a cost." % build_building_data)
    return

  if build_building_data != BuildingConfig.Buildings.NONE:
    # print_debug(event, ", building_data: ", build_building_data);
    self.building_to_build = build_building_data
    return
  
  if self.is_active:
    var mouseButtonEvent := event as InputEventMouseButton
    if mouseButtonEvent != null:
      if mouseButtonEvent.pressed == true:
        if mouseButtonEvent.button_index == MOUSE_BUTTON_LEFT:
          var building_cell_coords = built_tilemap.local_to_map(built_tilemap.to_local(built_tilemap.get_global_mouse_position()))
          var highlighted_building_instance := highlighter.highlighted_objects[0] as Building2D
          var action_set := highlighted_building_instance.get_first_node_of_type(BuildingActionSet) as BuildingActionSet
          var orientation := action_set.orientation if action_set != null else BuildingActionSet.Orientations._045

          build(building_cell_coords, self.building_size, self.building_to_build, orientation)

        if mouseButtonEvent.button_index == MOUSE_BUTTON_RIGHT:
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

    var rotation_angle = 0
    if event.is_action_pressed("rotate_building_left"):
      rotation_angle = 90
    if event.is_action_pressed("rotate_building_right"):
      rotation_angle = -90

    if rotation_angle != 0:
      var building_instance := highlighter.highlighted_objects[0] as Building2D
      var action_set := building_instance.get_first_node_of_type(BuildingActionSet) as BuildingActionSet
      action_set.orientation = posmod(action_set.orientation + rotation_angle, 360) # make in range of 0-359 

func _process(_delta):
  if self.is_active:
    var building_cell_coords = built_tilemap.local_to_map(built_tilemap.to_local(built_tilemap.get_global_mouse_position()))
    update_building_highlight(building_cell_coords)

func can_build_building(building_cell_starting_coords: Vector2i, size: Vector2i, building_name: StringName) -> bool:
  if building_name == BuildingConfig.Buildings.NONE:
    return false
  for dy in range(size.y):
    for dx in range(size.x):
      var building_cell_coords = building_cell_starting_coords - Vector2i(dx, dy)

      ## check if the reference object says that the tile is valid
      if reference_object != null and reference_object.has_method("is_tile_valid_for_building"):
        if reference_object.is_tile_valid_for_building(building_cell_coords) == false:
          return false
      
      # check if the tile is valid on the built_tilemap
      var is_road: bool = false
      var built_tile_data: TileData = built_tilemap.get_cell_tile_data(building_cell_coords)
      if built_tile_data != null and built_tile_data.terrain_set != -1: # if the built_tile_data is null, then it is not a road
        var built_terrain_name: String = built_tilemap.tile_set.get_terrain_name(built_tile_data.terrain_set, built_tile_data.terrain)# The terrain name of the tile.
        is_road = built_terrain_name == "DirtRoad" # Is the tile a road?
      var is_building: bool = built_tilemap.building_position_to_building.has(building_cell_coords) # Is the tile a building?
      if is_road or is_building: # If it is a road or a building, then the tile not valid
        return false
      
      # make sure that the terrain tile is valid
      var terrain_tile_data: TileData = terrain_tilemap.get_cell_tile_data(building_cell_coords)
      if terrain_tile_data != null and terrain_tile_data.terrain_set != -1:
        var terrain_name: String = terrain_tilemap.tile_set.get_terrain_name(terrain_tile_data.terrain_set, terrain_tile_data.terrain)
        if terrain_name == "Shallow" or terrain_name == "Deep":
          return false

  var is_enough_resources = self.has_resources_for_building(building_name)
  return is_enough_resources

func update_building_highlight(building_cell_coords: Vector2i) -> void:
  var building_instance: Building2D = null
  if building_cell_coords != self.last_highlighted_building_position or len(highlighter.highlighted_objects) == 0: # if the mouse moved or there is no highlighted building, then update the highlighter
    self.last_highlighted_building_position = building_cell_coords # update the last highlighted building position
    var prev_building_instance := highlighter.highlighted_objects[0] as Building2D if len(highlighter.highlighted_objects) > 0 else null
    var action_set := prev_building_instance.get_first_node_of_type(BuildingActionSet) as BuildingActionSet if prev_building_instance != null else null
    var prev_orientation := action_set.orientation if action_set != null else BuildingActionSet.Orientations._045
    highlighter.clear() # clear the highlighter
    var building_tileset_coords = BuildingConfig.building_to_tileset_id.get(self.building_to_build, -1)
    if building_tileset_coords == -1:
      push_error("Building %s does not have a tileset id" % self.building_to_build)
      return
    highlighter.set_cell(building_cell_coords, 0, Vector2i.ZERO, building_tileset_coords) # add the building highlight
    building_instance = await highlighter.new_building_added # wait for the building highlight to be added
    var new_action_set = building_instance.get_first_node_of_type(BuildingActionSet) if building_instance != null else null
    if new_action_set != null:
      new_action_set.orientation = prev_orientation

  elif building_instance == null: # The highlighted_objects is not empty because the previous if statement would be entered and set the building_instance
    building_instance = highlighter.highlighted_objects[0]
  # now that the building instance is not null, highlight is updated, and the shader is set, set the shader to correct color
  var building_instance_2D := building_instance as Building2D
  if building_instance_2D != null:
    self.building_size = building_instance_2D.size # cache the size
    var can_build := can_build_building(building_cell_coords, building_instance_2D.get_oriented_size(), self.building_to_build)
    building_instance_2D.set_can_build_highlight(can_build)

func has_resources_for_building(building_name: StringName) -> bool:
  var cost: Dictionary = BuildingConfig.building_to_cost[building_name] as Dictionary[StringName, int]
  for resource: StringName in cost.keys():
    var amount_needed: int = cost[resource]
    var amount_available = GameStats.game_stats_resource.resources.get(resource, 0)
    var can_be_built: bool = amount_available != null and amount_needed <= amount_available
    if not can_be_built:
      # in the future, tell the player the needed resources
      return false
  return true

func spend_resources_for_building(building_name: StringName) -> void:
  var cost: Dictionary = BuildingConfig.building_to_cost[building_name] as Dictionary[StringName, int]
  for resource: StringName in cost.keys():
    var amount_needed: int = cost[resource]
    GameStats.game_stats_resource.add_resource(resource, -amount_needed)
    print("the amount of %s is now %s" % [str(resource).capitalize(), GameStats.game_stats_resource.resources[resource]])

func build(building_cell_coords: Vector2i, building_size: Vector2i, building_to_build: StringName, orientation: BuildingActionSet.Orientations) -> void:
  # TODO: the can_build_building check is not full: the size here is not available, since there is no instance of the building. Does it need to be checked there again after highlight?
  if building_to_build != BuildingConfig.Buildings.NONE and can_build_building(building_cell_coords, building_size, building_to_build): # If there is a building to build and it can be built
    spend_resources_for_building(self.building_to_build)
    built_tilemap.set_cell(building_cell_coords, 0, Vector2i.ZERO, BuildingConfig.building_to_tileset_id.get(self.building_to_build, -1))
    highlighter.clear()
    var res = await built_tilemap.buildings_built
    var building := res[0] as Building2D
    # var cells := res[1] as Array[Vector2i]
    var action_set := building.get_first_node_of_type(BuildingActionSet) as BuildingActionSet if building != null else null
    if action_set != null:
      action_set.orientation = orientation
    pass
