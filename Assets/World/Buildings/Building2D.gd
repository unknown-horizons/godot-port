@tool

extends WorldThing2D

class_name Building2D

var __repr__: String:
  get():
    return "Building2D(%s, %s)<%s>" % [id, self.get_name(), self.get_instance_id()]
#@export var production_chain: ProductionChain

@export var id: StringName = &"Building"
@export var baseclass: String       # TODO: not used yet

@export var game_name_per_tier: Dictionary[StringName, String]
@export var radius: int             # radius collector uses if collector doesn't have overridden radius
@export var cost: int               # cost per game_second
@export var cost_inactive: int      # TODO: not used yet
@export var size: Vector2i = Vector2i(1, 1) # building footpring in cells
@export var inhabitants: int        # TODO: not used yet
@export var tooltip_text: String    # TODO: not used yet
@export var tier: String            # TODO: not used yet. Supposed to be a tier when the building unlocks

## The terrain the building can be built on per tile: [code]Array[Array[int]][/code],
## Ex: [code][[0, 0],[0, 0]][/code],[br]
## encoded as a bitmask of [(any_building](mountain)(iron deposit)(clay deposit)(Deep)(Shallow)(Beach)(Grass)] * amount of tiles[br]
## The first four bits are responsible for [b]required[/b] buildings on cell.[br]
## The last four bits are responsible for [b]allowed[/b] terrain.[br]
## Examples: tile buildable on grass would be 0b00000001, buildable on coastline would be 000010 = 2
## if buildable on coastline or grass, it would be 00000011 = 3 and so on[br]
## empty means the building can be built on Grass
@export var buildable_on: Array[Array] = []
@export var current_tier: StringName = WorldTiers.Tiers.MAX:
  set(value):
    current_tier = value
    _on_tier_changed() # to be overloaded
var current_tier_val: WorldTiers.TierEnum:
  get():
    return WorldTiers.TierEnum.get(self.current_tier, WorldTiers.TierEnum.SAILORS)

# buildingcosts - in BuildingConfig.gd
@export var show_status_icons: bool # TODO: not used yet

var game_name: String:
  get():
    var latest_name = "NameNotSet"
    for tier_name in WorldTiers.TierEnum.keys():
      if self.game_name_per_tier.has(tier_name):
        latest_name = self.game_name_per_tier[tier_name]
      if tier_name == self.current_tier:
        break
    return latest_name

## is building paused
@export var paused: bool = true:
  set(value):
    paused = value
    for node: Node in self.get_children():
      var component := node as BaseComponent
      if component != null:
        component.paused = self.paused
    if self.paused == false:
      unpaused.emit()

signal unpaused

var resources_produced: Dictionary[StringName, bool]
var resources_consumed: Dictionary[StringName, bool]

## setter for current_tier
func _on_tier_changed() -> void:
  var enum_tier: WorldTiers.TierEnum = WorldTiers.TierEnum.get(self.current_tier, WorldTiers.TierEnum.SAILORS)
  for node: Node in self.get_children():
    if "current_tier" in node:
      if node.current_tier is StringName: # if uses StringName
        node.current_tier = self.current_tier
      elif node.current_tier is WorldTiers.TierEnum: # if uses enum
        node.current_tier = enum_tier
  var world_enum_tier: WorldTiers.TierEnum = WorldTiers.TierEnum.get(GameStats.game_stats_resource.world_tier, WorldTiers.TierEnum.SAILORS)
  if world_enum_tier < enum_tier:
    GameStats.game_stats_resource.world_tier = self.current_tier

  self.refresh_resources_produced_consumed()

## Changes current_tier if needed
func update_tier() -> void:
  self.current_tier = GameStats.game_stats_resource.world_tier

func _ready():
  CamUtils.center_if_no_camera(self)
  self.add_to_group("Buildings")
  if Engine.is_editor_hint():
    self.set_notify_transform(true)
    return
  self.paused = self.paused # call pause setter
  # handle world tier
  setup_components()
  self.current_tier = GameStats.game_stats_resource.world_tier
  self.update_tier()
  self.connect_set_tier()

## Called when to connect set_tier connections
func connect_set_tier() -> void:
  GameStats.game_stats_resource.world_tier_changed.connect(self.update_tier)

func setup_components() -> void:
  # get a list of all the child components
  var components: Array[BaseComponent]
  for child in self.get_children():
    if child is BaseComponent:
      components.append(child)
  # give all the components the list of all their neighboring components
  for component in components:
    component.set_components(components)

func refresh_resources_produced_consumed():
  var resources_produced: Dictionary[StringName, bool] = {}
  var resources_consumed: Dictionary[StringName, bool] = {}
  for node: Node in self.get_children():
    var production_line_component := node as ProductionLineComponent
    if production_line_component != null:
      for resource in production_line_component.produces:
        resources_produced[resource] = true
      for resource in production_line_component.consumes:
        resources_consumed[resource] = true
  self.resources_produced = resources_produced
  self.resources_consumed = resources_consumed


func unload_resource(resource: StringName, amount: int) -> void:
  if resource == ResourceConfig.Resources.NONE:
    return
  var storage_component: StorageComponent = self.get_first_node_of_type(StorageComponent)
  if storage_component == null or self.is_inside_tree() == false:
    return
  
  var successful := await self.sleep(storage_component.load_or_unload_time)
  if successful == false:
    return
  var amount_in_storage: int = storage_component.get_storage_item_amount(resource)
  storage_component.set_storage_item_amount(resource, amount_in_storage + amount)

func load_resource(resource: StringName, amount: int) -> int:
  if resource == ResourceConfig.Resources.NONE:
    return 0
  var storage_component: StorageComponent = self.get_first_node_of_type(StorageComponent)
  if storage_component == null:
    return 0

  var successful := await self.sleep(storage_component.load_or_unload_time)
  if successful == false:
    return 0
  var available_amount: int = storage_component.get_storage_item_amount(resource)
  var amount_to_load: int = min(amount, available_amount)
  storage_component.set_storage_item_amount(resource, available_amount - amount_to_load)

  return amount_to_load

func set_can_build_highlight(can_build: bool) -> void:
  for node: Node in self.get_children():
    var action_set := node as BuildingActionSet
    if action_set != null:
      action_set.set_can_build_shader(can_build)

func get_oriented_size() -> Vector2i:
  var size_x = self.size.x
  var size_y = self.size.y
  if size_x != size_y: # for rectangular building, swap size_x and size_y if at particular orientation
    var action_set := self.get_first_node_of_type(BuildingActionSet) as BuildingActionSet
    if action_set == null:
      push_error("Building %s is not square and has no building action set to get orientation from" % self.name)
    var orientation := action_set.orientation if action_set != null else BuildingActionSet.Orientations._045
    if orientation == BuildingActionSet.Orientations._045 or orientation == BuildingActionSet.Orientations._225:
      size_x = self.size.y
      size_y = self.size.x
  return Vector2i(size_x, size_y)

@onready var built_tilemap: BuiltTileMap = self.get_node("/root/Main/BuiltTileMap") if not Engine.is_editor_hint() else null

var cell_position: Vector2i:
  get():
    return self.built_tilemap.local_to_map(self.global_position) if self.built_tilemap != null else Vector2i.ZERO

var oriented_rect: Rect2i:
  get():
    var rect = Rect2i(self.cell_position+Vector2i(1,1), -self.get_oriented_size()).abs()
    return rect

## Returns an array of array of Vector2i (cell offsets) based on current orientation from _045 orientation
func get_oriented_cells() -> Array[Array]:
  # get action set
  var action_set := self.get_first_node_of_type(BuildingActionSet) as BuildingActionSet
  if action_set == null:
    push_error("Building %s has no BuildingActionSet to get orientation from" % self.name)
    return []
  var orientation := action_set.orientation

  var oriented_cells: Array[Array] = []
  oriented_cells.resize(self.size.y)
  for dy in range(self.size.y):
    var row: Array[Vector2i] = []
    row.resize(self.size.x)
    oriented_cells[dy] = row
    for dx in range(self.size.x):
      var cell: Vector2i
      match orientation: # Calculate the cell position acording to orientation
        BuildingActionSet.Orientations._045:
          cell = -Vector2i(dy, dx) # axis switched
        BuildingActionSet.Orientations._135:
          # 90° from original, axis stays same, dy inverted(from end)
          cell = -Vector2i(dx , size.y - 1 - dy)
        BuildingActionSet.Orientations._225:
          # 180° from original, dx and dy inverted, axis switched
          cell = -Vector2i(self.size.y - dy - 1, self.size.x - dx - 1)
        BuildingActionSet.Orientations._315:
          # 270° from original, axis stay same, dx inverted(from end)
          cell = -Vector2i(size.x - 1 - dx, dy)
      row[dx] = cell

  return oriented_cells

func _notification(what):
  if what == NOTIFICATION_TRANSFORM_CHANGED:
    if Engine.is_editor_hint():
      var built_tilemap := self.get_parent() as BuiltTileMap
      if built_tilemap != null:
        self.position = built_tilemap.map_to_local(built_tilemap.local_to_map(self.position)) # snap position to cells in editor mode

var buildings_in_radius_cache: Array[Building2D]
var buildings_in_radius_cache_radius: int = -1
# var buildings_paths_cache: Dictionary[Building2D, NavPath] = {}
var buildings_paths_cache: Dictionary[Building2D, Dictionary] = {} # Dictionary[Building2D, Dictionary[Pathfinder, NavPath]] = {}

func get_buildings_in_radius(radius: int) -> Array[Building2D]:
  if buildings_in_radius_cache_radius < radius:
    self.buildings_in_radius_cache = self.built_tilemap.get_buildings_in_radius(self.oriented_rect, radius)
    self.buildings_in_radius_cache.erase(self) # remove self from the list

  return self.buildings_in_radius_cache

func get_path_to_building(building: Building2D, pathfinding: Pathfinder) -> NavPath:
  var pathfinder_to_path_cache: Dictionary[Pathfinder, NavPath]
  if not self.buildings_paths_cache.has(building):
    pathfinder_to_path_cache = {}
    self.buildings_paths_cache[building] = pathfinder_to_path_cache
  else:
    pathfinder_to_path_cache = self.buildings_paths_cache[building]
  # var path: NavPath = pathfinder_to_path_cache.get(pathfinding, null) if pathfinder_to_path_cache != null else null

  var path: NavPath
  if pathfinder_to_path_cache.has(pathfinding):
    path = pathfinder_to_path_cache[pathfinding]
  else:
    path = self.built_tilemap.get_building_to_building_path(self, building, pathfinding)
    pathfinder_to_path_cache[pathfinding] = path

  return path

func invalidate_cache(_cells: Array[Vector2i]):
  # TODO: use cells to limit the invalidate region
  self.buildings_in_radius_cache = []
  self.buildings_in_radius_cache_radius = -1
  self.buildings_paths_cache = {}
  print("Building %s cache invalidated" % self.__repr__)

func get_resources_produced_amounts() -> Dictionary[StringName, int]:
  var resources_produced_amounts: Dictionary[StringName, int] = {}
  for storage_component: StorageComponent in self.get_all_nodes_of_type(StorageComponent):
    for resource in resources_produced.keys():
      var storage_amount := storage_component.get_storage_item_amount(resource)
      resources_produced_amounts[resource] = resources_produced_amounts.get(resource, 0) + storage_amount
  return resources_produced_amounts


func get_resource_amount(resource: StringName) -> int:
  var resource_amount := 0
  for storage_component: StorageComponent in self.get_all_nodes_of_type(StorageComponent):
    resource_amount += storage_component.get_storage_item_amount(resource)
  return resource_amount

func get_max_resource_amount(resource: StringName) -> int:
  var max_resource_amount := 0
  for storage_component: StorageComponent in self.get_all_nodes_of_type(StorageComponent):
    max_resource_amount = max(max_resource_amount, storage_component.get_max_capacity(resource))
  return max_resource_amount
