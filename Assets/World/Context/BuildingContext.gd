extends BaseContext
## The BuildingContext is responsible for building buildings.

class_name BuildingContext

@export var default_cursor: Texture2D = preload("res://Assets/UI/Images/Cursors/Cursor.png")

@onready var object_selected_context: ObjectSelectedContext = self.get_node("/root/Main/GameContextManager/ObjectSelectedContext") if not Engine.is_editor_hint() else null
@onready var terrain_tilemap: TerrainTileMap = %TerrainTileMap
@onready var built_tilemap: BuiltTileMap = %BuiltTileMap

## The building to build.
## Note: The context will become active and reset the reference object if the property is set.
var building_to_build: StringName = BuildingConfig.Buildings.NONE:
  get:
    return building_to_build
  set(value):
    if self.building_instance != null:
      self.building_instance.queue_free()
    building_to_build = value
    reference_object = null
    if building_to_build == BuildingConfig.Buildings.NONE:
      self.building_instance = null
      return
    # var building_cell_coords = built_tilemap.local_to_map(built_tilemap.to_local(built_tilemap.get_global_mouse_position()))
    var packed_scene = BuildingConfig.buildings_packed_scenes.get(building_to_build, null)
    if packed_scene == null:
      push_error("Cannot find packed scene in `BuildingConfig.buildings_packed_scenes` for building `%s`" % building_to_build)
      return
    self.building_instance = packed_scene.instantiate()
    self.building_instance.position = built_tilemap.to_local(built_tilemap.get_global_mouse_position())
    self.built_tilemap.add_child(self.building_instance)

    self.update_building_highlight()

    if not self.is_active:
      self.game_context_manager.current_context = self
    self.building_changed.emit(self.building_to_build)

var building_instance: Building2D = null

var building_oriented_size: Vector2i

## The object that is used as a reference for the building placement and other things.
## If a additional check for valid building tile is desired, the object must have a function, "is_tile_valid_for_building(building_tile_position)".
var reference_object: WorldThing2D = null

var last_highlighted_building_position: Vector2i

signal building_changed(building: StringName)

func context_entered() -> void:
  Input.set_custom_mouse_cursor(self.default_cursor)

# clear the highlights
func context_exited() -> void:
  super()
  self.cancel_build()
  # highlighter.clear()

func _ready() -> void:
  GameStats.game_stats_resource.resources_changed.connect(update_building_highlight)

func _unhandled_input(event: InputEvent) -> void:
  var build_building_data: StringName = BuildingConfig.Buildings.NONE

  if event.is_action_pressed("toggle_build_building"):
    build_building_data = event.get_meta("button_name").trim_prefix("Build").trim_suffix("Button")
    if build_building_data == "Trail":
      return # road building is handled in the RoadContext
    build_building_data = build_building_data.to_snake_case().to_upper()
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
    var mouse_move_event := event as InputEventMouseMotion
    if mouse_move_event != null:
      self.update_building_highlight()

    var mouseButtonEvent := event as InputEventMouseButton
    if mouseButtonEvent != null and mouseButtonEvent.pressed:
      if mouseButtonEvent.button_index == MOUSE_BUTTON_LEFT:
        self.build(self.building_to_build, self.building_instance)
        return

    if event.is_action_pressed("cancel"): # cancel the build
      if reference_object != null: # if reference_object was used, select it on build cancel
        var selectable := reference_object.find_first_node_of_type(Selectable) as Selectable
        if selectable != null: # if a selectable was found then set it as selected
          self.game_context_manager.current_context = object_selected_context
          object_selected_context.set_selected_objects([selectable])
          return
      self.cancel_build()
      self.game_context_manager.current_context = null # if cannot get the selectable of the reference object then set the context to null

    var rotation_angle = 0
    if event.is_action_pressed("rotate_building_left"):
      rotation_angle = 90
    if event.is_action_pressed("rotate_building_right"):
      rotation_angle = -90

    if rotation_angle != 0:
      var action_set := self.building_instance.get_first_node_of_type(BuildingActionSet) as BuildingActionSet
      action_set.orientation = posmod(action_set.orientation + rotation_angle, 360) # make in range of 0-359
      self.update_building_highlight()

func update_building_highlight() -> void:
  if self.is_active and self.building_instance != null:
    var building_cell_coords = built_tilemap.local_to_map(built_tilemap.to_local(built_tilemap.get_global_mouse_position()))
    self.building_instance.position = built_tilemap.map_to_local(building_cell_coords) # rounded_pos
    var can_build := self.can_build_building(building_cell_coords, self.building_instance.get_oriented_cells(), self.building_to_build)
    self.building_instance.set_can_build_highlight(can_build)

func can_build_building(building_cell_starting_coords: Vector2i, oriented_cells: Array[Array], building_name: StringName) -> bool:
  if building_name == BuildingConfig.Buildings.NONE:
    return false
  for y in len(oriented_cells):
    for x in len(oriented_cells[y]):
      var dv: Vector2i = oriented_cells[y][x]
      var building_cell_coords = building_cell_starting_coords + dv

      ## check if the reference object says that the cell is valid
      if reference_object != null and reference_object.has_method("is_tile_valid_for_building"):
        if reference_object.is_tile_valid_for_building(building_cell_coords) == false:
          return false

      # check if the cell is vaild in terms of road
      var is_road: bool = false
      var built_tile_data: TileData = built_tilemap.get_cell_tile_data(building_cell_coords)
      if built_tile_data != null and built_tile_data.terrain_set != -1: # if the built_tile_data is null, then it is not a road
        var built_terrain_name: String = built_tilemap.tile_set.get_terrain_name(built_tile_data.terrain_set, built_tile_data.terrain)# The terrain name of the cell.
        is_road = built_terrain_name == "DirtRoad" # Is the cell a road?
      if is_road:
        return false # cannot build on road, atleast for now

      # check if the cell is buildable
      var terrain_bitmask: int = self.terrain_tilemap.get_cell_terrain_bitmask(building_cell_coords) # use the terrain bitmask
      var building_bitmask: int = self.built_tilemap.get_cell_building_bitmask(building_cell_coords)
      # get the bitmask for the buildable cell of a building, inverse because stored left to right, top to bottom
      var buildable_cell_bitmask: int = 0b0000001 # by default the building can only be built on grass
      if len(building_instance.buildable_on) > 0:
        # in tscn, the array is top to bottom, but we build bottom to top, hence inverse y
        buildable_cell_bitmask = building_instance.buildable_on[len(oriented_cells) - 1 - y][x]
      # check if the cell is buildable using allowed by terrain and required by building
      var buildable_on_cell: bool = ((buildable_cell_bitmask & 0b00001111) & terrain_bitmask) != 0 # allowed by terrain(one match)
      buildable_on_cell = buildable_on_cell and (buildable_cell_bitmask & 0b11110000) == building_bitmask # required by building(all matching)
      if buildable_on_cell == false:
        return false

  var is_enough_resources = self.has_resources_for_building(building_name)
  return is_enough_resources

func build(building_to_build: StringName, building_instance: Building2D) -> void:
  if building_instance != null: # If there is a building to build and it can be built
    var building_cell_coords = built_tilemap.local_to_map(building_instance.position)
    if self.can_build_building(building_cell_coords, self.building_instance.get_oriented_cells(), building_to_build):
      var building: Building2D = building_instance
      self.building_instance = null # detach the instance first, the instance will remain stored in the built_tilemap
      self.spend_resources_for_building(self.building_to_build)
      built_tilemap.build(building)
      self.building_to_build = self.building_to_build
      GameStats.game_stats_resource.resources_changed.emit() # trigger other buildings to look for resources again (including this building)
      # self.building_to_build = BuildingConfig.Buildings.NONE # then clear the building to be built
      # self.game_context_manager.current_context = null # release the context

func cancel_build() -> void:
  self.building_to_build = BuildingConfig.Buildings.NONE

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
