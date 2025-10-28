@tool

extends WorldThing2D

class_name Building2D

#@export var production_chain: ProductionChain

@export var id: StringName = &"Building"
@export var baseclass: String       # TODO: not used yet

@export var game_name_per_tier: Dictionary[StringName, String]
@export var radius: int             # TODO: not used yet
@export var cost: int               # TODO: not used yet
@export var cost_inactive: int      # TODO: not used yet
@export var size: Vector2i = Vector2i(1, 1)
@export var inhabitants: int        # TODO: not used yet
@export var tooltip_text: String    # TODO: not used yet
@export var tier: String            # TODO: not used yet

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

## Changes current_tier if needed
func update_tier() -> void:
  self.current_tier = GameStats.game_stats_resource.world_tier

func _ready():
  CamUtils.center_if_no_camera(self)
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

func is_resource_available(resource: StringName) -> bool:
  for component in self.get_children():
    var production_line := component as ProductionLineComponent
    if production_line != null:
      if production_line.consumes.has(resource) == true:
        return false # if the building consumes the resource, do not take that resource from the building
  for component in self.get_children():
    var storage_component := component as StorageComponent
    if storage_component != null:
      # prints("      Looking for %s in %s" % [resource, self.name])
      if storage_component.get_storage_item_amount(resource) > 0:
        return true # found in at least one of the storages

  return false

func unload_resource(resource: StringName, amount: int) -> void:
  if resource == ResourceConfig.Resources.NONE:
    return
  var storage_component: StorageComponent = self.get_first_node_of_type(StorageComponent)
  if storage_component == null:
    return
  
  await self.sleep(storage_component.load_or_unload_time)
  var amount_in_storage: int = storage_component.get_storage_item_amount(resource)
  storage_component.set_storage_item_amount(resource, amount_in_storage + amount)

func load_resource(resource: StringName, amount: int) -> int:
  if resource == ResourceConfig.Resources.NONE:
    return 0
  var storage_component: StorageComponent = self.get_first_node_of_type(StorageComponent)
  if storage_component == null:
    return 0

  await self.sleep(storage_component.load_or_unload_time)
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
    var actionset := self.get_first_node_of_type(BuildingActionSet) as BuildingActionSet
    if actionset == null:
      push_error("Building %s is not square and has no building action set to get orientation from" % self.name)
    var orientation := actionset.orientation if actionset != null else BuildingActionSet.Orientations._045
    if orientation == BuildingActionSet.Orientations._045 or orientation == BuildingActionSet.Orientations._225:
      size_x = self.size.y
      size_y = self.size.x
  return Vector2i(size_x, size_y)

func _notification(what):
  if what == NOTIFICATION_TRANSFORM_CHANGED:
    if Engine.is_editor_hint():
      var built_tilemap := self.get_parent() as BuiltTileMap
      if built_tilemap != null:
        self.position = built_tilemap.map_to_local(built_tilemap.local_to_map(self.position)) # snap position to cells in editor mode
