extends WorldThing2D

class_name Building2D

#@export var production_chain: ProductionChain

@export var id: StringName = &"Building"

@export var baseclass: String       # TODO: not used yet
@export var radius: int             # TODO: not used yet
@export var cost: int               # TODO: not used yet
@export var cost_inactive: int      # TODO: not used yet
@export var size: Vector2i = Vector2i(1, 1)
@export var inhabitants: int        # TODO: not used yet
@export var tooltip_text: String    # TODO: not used yet
@export var tier: String            # TODO: not used yet
# buildingcosts - in BuildingConfig.gd
@export var show_status_icons: bool # TODO: not used yet

## is building paused
var paused: bool = true:
  set(value):
    paused = value
    for node: Node in self.get_children():
      var component: BaseComponent = node as BaseComponent
      if component != null:
        component.paused = self.paused
    if self.paused == false:
      unpaused.emit()

signal unpaused

func _ready():
  setup_components()
  CamUtils.center_if_no_camera(self)

## returns all the components of the certain type
func get_components(component_type: Variant = BaseComponent) -> Array:
  var components: Array = []
  for component in self.get_children():
    if is_instance_of(component, component_type):
      components.append(component)
  return components

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
    var storage_component := component as StorageComponent
    if storage_component != null:
      if storage_component.get_storage_item_amount(resource) > 0:
        return true # found in at least one of the storages

  return false

func get_needed_resources() -> Array[StringName]:
  var production_lines: Array[ProductionLineComponent] = []
  var slot_storage: SlotStorageComponent = null
  var sized_storage: SizedStorageComponent = null

  for component in self.get_children(): # get a list of all the production line components and the storage component
    var production_line: ProductionLineComponent = component as ProductionLineComponent
    if production_line != null:
      production_lines.append(production_line)
    if component is SlotStorageComponent:
      slot_storage = component
    if component is SizedStorageComponent:
      sized_storage = component
  
  var needed_resources: Dictionary[StringName, int] = {}

  for production_line in production_lines: # get a list of all the resources needed
    needed_resources.merge(production_line.consumes)
  
  for resource in needed_resources.keys(): # get the amount of each resource needed
    if resource == ResourceConfig.Resources.NONE:
      continue
    var max_amount: int = 0
    var amount_in_stock: int = 0
    var amount_needed: int = 0

    if sized_storage != null:
      max_amount = sized_storage.limit
      amount_in_stock = sized_storage.storage.get(resource)
    elif slot_storage != null:
      max_amount = slot_storage.max_capacity.get(resource, 0)
      amount_in_stock = slot_storage.storage.get(resource, 0)
    
    amount_needed = max_amount - amount_in_stock
    needed_resources[resource] = amount_needed

  var needed_resources_sorted: Array[StringName] = needed_resources.keys()
  needed_resources_sorted.sort_custom(func(a, b): return needed_resources[a] > needed_resources[b])

  return needed_resources.keys()

func unload_resource(resource: StringName, amount: int) -> void:
  if resource == ResourceConfig.Resources.NONE:
    return
  var storage_components: Array = self.get_components(SlotStorageComponent)
  if storage_components == []:
    return
  var storage_component: SlotStorageComponent = storage_components[0] as SlotStorageComponent
  
  await self.sleep(storage_component.load_or_unload_time)
  var amount_in_storage: int = storage_component.storage.get(resource)
  storage_component.set_storage_item_amount(resource, amount_in_storage + amount)

func load_resource(resource: StringName, amount: int) -> int:
  if resource == ResourceConfig.Resources.NONE:
    return 0
  var storage_components: Array = self.get_components(SlotStorageComponent)
  if storage_components == []:
    return 0
  var storage_component: SlotStorageComponent = storage_components[0] as SlotStorageComponent

  await self.sleep(storage_component.load_or_unload_time)
  var available_amount: int = storage_component.storage.get(resource, 0)
  var amount_to_load: int = min(amount, available_amount)
  storage_component.set_storage_item_amount(resource, available_amount - amount_to_load)

  return amount_to_load

func set_can_build_highlight(can_build: bool) -> void:
  for node: Node in self.get_children():
    var action_set: BuildingActionSet = node as BuildingActionSet
    if action_set != null:
      action_set.set_can_build_shader(can_build)
