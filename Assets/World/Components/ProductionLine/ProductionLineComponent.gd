extends BaseComponent
## Simulates production of resources
##
## The production line is a component that produces resources from consumed resources.[br]
## It collects resources from sibling storages and puts the produced resource into the first one in the tree order.

class_name ProductionLineComponent

@export_group("production")
@export var line_name: String = ""
## The resources needed to produce the output product
@export var consumes: Dictionary[StringName, int] = {}:
  set(value):
    consumes = value

## The product that will be produced[br]
## [b]Note[/b]: Only [b]one[/b] resource can be produced
@export var produces: Dictionary[StringName, int] = {}

@export var production_time: float = 10
## The multiplier applied to consumed and produced resources' amounts.
@export var consumes_multiplier: int = 1: set = set_consumes_multiplier
@export var produces_multiplier: int = 1: set = set_produces_multiplier
@export_group("")

@export var levels: Array[StringName] = []

@export var show_resource_produced_tooltip: bool = true
@export var show_resource_deficit_tooltip: bool = true
@export var show_inventory_full_tooltip: bool = true

## The tooltip that shows that there are not enough resources to produce
@onready var resource_deficit_tooltip: AnimatedSprite2D = %ResourceDeficitTooltip
## The tooltip that shows that the inventory is full
@onready var inventory_full_tooltip: AnimatedSprite2D = %InventoryFullTooltip

@onready var item_produced_tooltip: Control = self.get_node("ItemProducedTooltip")
@onready var resource_image_placeholder: TextureRect = self.get_node("ItemProducedTooltip/Background/HBoxContainer/ItemImagePlaceholder/ItemImage"):
  set(value):
    resource_image_placeholder = value
    if resource_image_placeholder != null and len(produces.keys()) > 0:
      resource_image_placeholder.texture = produces.keys()[0].icon # set the image
@onready var resource_amount_placeholder: Label = self.get_node("ItemProducedTooltip/Background/HBoxContainer/ItemAmountPlaceholder/ItemAmount"):
  set(value):
    resource_amount_placeholder = value
    if resource_amount_placeholder != null and len(produces.keys()) > 0:
      resource_amount_placeholder.text = produces.values()[0] # set the amount


## The production stages for the component.
enum ProductionStages {
  ## The enum val representing the paused status.
  IDLE,
  ## The enum val representing the start of production.[br]
  ## Note: Will start the production loop
  START,
  ## The enum val representing the waiting for resources status
  WAITING_FOR_RESOURCES,
  ## The enum val representing the producing status
  PRODUCING
}

## The current production stage.[br]
## If set to [constant  ProductionLineComponent.ProductionStages.START] from [constant  ProductionLineComponent.ProductionStages.IDLE], will start producing.
var production_stage: ProductionStages = ProductionStages.IDLE:
  set(value):
    var last_stage: ProductionStages = production_stage
    production_stage = value
    if last_stage != production_stage:
      update_action_set()
    if last_stage == ProductionStages.IDLE and production_stage == ProductionStages.START:
      production_loop()


var production_time_end: float = 0

var storage_components: Array[StorageComponent]

var action_set: BuildingActionSet = null

var current_tier := WorldTiers.Tiers.SAILORS:
  set(value):
    current_tier = value
    var parent_building: Building2D = self.get_parent() as Building2D
    # update the paused state with the new tier
    if parent_building != null:
      if parent_building.paused == false:
        self.unpause_if_can()
    else:
      push_error("parent is not a building for production line")
      self.paused = false

signal action_state_changed(action_state: ActionStates)

func unpause_if_can():
  if self.levels == []:
    self.paused = false
    return
  self.paused = (self.current_tier in self.levels) == false

func set_components(components: Array[BaseComponent]):
  for component in components:
    var storage_component = component as StorageComponent
    var action_set = component as BuildingActionSet
    if storage_component != null:
      self.storage_components.append(storage_component)
    if action_set != null:
      self.action_set = action_set
  if self.paused:
    await self.unpaused
  # set the tooltip positions
  var building_local_top := self.get_local_building_height()
  self.resource_deficit_tooltip.position = building_local_top
  self.inventory_full_tooltip.position = building_local_top
  production_stage = ProductionStages.START

func update_action_set():
  if action_set != null:
    match production_stage:
      ProductionStages.IDLE:
        self.action_state_changed.emit(ActionStates.IDLE)
      ProductionStages.WAITING_FOR_RESOURCES:
        self.action_state_changed.emit(ActionStates.IDLE)
      ProductionStages.PRODUCING:
        self.action_state_changed.emit(ActionStates.WORK)

func notify_resource_produced():
  if self.show_resource_produced_tooltip == false or self.is_inside_tree() == false:
    return
  if len(produces.keys()) <= 0: # check that there is an output product
    return
  var starting_tooltip_position: Vector2 = item_produced_tooltip.position # the starting position of tooltip
  # set the visuals
  resource_image_placeholder.texture = ResourceConfig.resource_to_icon.get(produces.keys()[0]) # set the image
  resource_amount_placeholder.text = str(produces.values()[0]) # set the amount
  item_produced_tooltip.visible = true
  # move the tooltip
  var move_tween: Tween = self.get_tree().create_tween().bind_node(self)
  move_tween.tween_property(item_produced_tooltip, "position", starting_tooltip_position + Vector2(0, -48), 48/24)# move up 24 px per sec
  await move_tween.finished
  # reset the tooltip
  item_produced_tooltip.visible = false
  item_produced_tooltip.position = starting_tooltip_position

## updates the resource storage tooltips[br]
## [member ProductionLineComponent.resource_deficit_tooltip] depending on the has_enough_resources
## and [member ProductionLineComponent.inventory_full_tooltip] depending on the has_output_space
func update_resource_storage_tooltips(has_enough_resources: bool, has_output_space: bool):
  if self.show_inventory_full_tooltip:
    if has_output_space == false: # show full output
      if self.inventory_full_tooltip.visible == false:
        self.inventory_full_tooltip.visible = true
        self.inventory_full_tooltip.play("inventory_full")
    elif self.inventory_full_tooltip.visible == true:
      self.inventory_full_tooltip.visible = false
      self.inventory_full_tooltip.stop()

  if self.show_resource_deficit_tooltip:
    if has_enough_resources == false and has_output_space == true: # show resource deficit
      if self.resource_deficit_tooltip.visible == false:
        self.resource_deficit_tooltip.visible = true
        self.resource_deficit_tooltip.play("resource_deficit")
    elif self.resource_deficit_tooltip.visible == true:
      self.resource_deficit_tooltip.visible = false
      self.resource_deficit_tooltip.stop()

## returns the local top position of the building
func get_local_building_height() -> Vector2:
  var building_height: Vector2 = self.global_position
  var parent_building: Building2D = self.get_parent() as Building2D
  if parent_building != null:
    var built_tilemap: BuiltTileMap = self.get_node("/root/Main/BuiltTileMap")
    # calculate the top position
    var oriented_size: Vector2i = parent_building.get_oriented_size()
    var top_cell_dy := 1 - oriented_size.x
    building_height = Vector2i(0, int(built_tilemap.tile_set.tile_size.y * (top_cell_dy - 0.5)))
  return building_height

func has_output_space() -> bool:
  if self.produces == {}:
    return true
  for produces in self.produces.keys():
    for storage_component in self.storage_components:
      var current_amount := storage_component.get_storage_item_amount(produces)
      var max_amount: int = storage_component.get_max_capacity(produces)
      if current_amount < max_amount:
        return true
  return false

func has_enough_resources() -> bool:
  if self.storage_components == []: # if there is no storage then no resources
    return false
  for resource in self.consumes.keys():
    var available_resource_amount: int = 0
    var needed_resource_amount: int = self.consumes[resource] * self.consumes_multiplier
    for storage_component in self.storage_components:
      available_resource_amount += storage_component.get_storage_item_amount(resource)
    if available_resource_amount < needed_resource_amount:
      return false
  return true

func spend_resources():
  if self.storage_components == []: # if there is no storage then no resources
    return
  for resource in self.consumes.keys():
    var needed_resource_amount: int = self.consumes[resource]
    var storage_index: int = 0
    while needed_resource_amount > 0:
      if storage_index >= len(self.storage_components):
        push_error("not enough resources at spending stage %s" % [self.get_parent().name])
        return
      var current_resource_amount: int = self.storage_components[storage_index].get_storage_item_amount(resource)
      var resource_amount_used: int = min(needed_resource_amount, current_resource_amount)
      self.storage_components[storage_index].set_storage_item_amount(resource, current_resource_amount - resource_amount_used)
      needed_resource_amount -= resource_amount_used
      storage_index += 1
    # else:
    #   push_error("not enough resources at spending stage.")


func production_loop():
  if self.is_node_ready() == false:
    await self.ready
  await self.sleep(randf_range(0, 3)) # random delay to avoid same-time production on map start
  while production_stage != ProductionStages.IDLE and self.storage_components != []:
    await wait_for_resources()
    await produce()

func wait_for_resources():
  production_stage = ProductionStages.WAITING_FOR_RESOURCES

  while true:
    var has_enough_resources := self.has_enough_resources()
    var has_output_space := self.has_output_space()
    self.update_resource_storage_tooltips(has_enough_resources, has_output_space)
    if has_enough_resources and has_output_space:
      break # if all good for production, then break

    await sleep(1) # check again in 1 second # TODO: switch to storage events

    if self.paused:
      await self.unpaused

func produce():
  # if len(produces.keys()) <= 0:
  #   return
  if self.storage_components == []:
    push_error("no storage components")
  production_stage = ProductionStages.PRODUCING
  # simulate production, TODO: switch to Timer for game speed awareness and pauseability
  self.production_time_end = Time.get_unix_time_from_system() + production_time
  await self.sleep(production_time)
  if self.paused:
    await self.unpaused
  spend_resources()
  for produced_resource_name in self.produces:
    var current_amount := self.storage_components[0].get_storage_item_amount(produced_resource_name)
    var produced_amount = self.produces[produced_resource_name]
    self.storage_components[0].set_storage_item_amount(produced_resource_name, current_amount + produced_amount * self.produces_multiplier)
  notify_resource_produced()


func set_consumes_multiplier(multiplier: int):
  consumes_multiplier = multiplier

func set_produces_multiplier(multiplier: int):
  produces_multiplier = multiplier
