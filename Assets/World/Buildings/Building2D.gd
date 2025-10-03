extends WorldThing2D

class_name Building2D

#@export var production_chain: ProductionChain

func _ready():
  setup_components()
  CamUtils.center_if_no_camera(self)

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
  var slot_storage: SlotStorageComponent = null

  for component in self.get_children():
    var production_line: ProductionLineComponent = component as ProductionLineComponent
    if production_line != null:
      if production_line.produces.has(resource) == false:
        return false
    if component is SlotStorageComponent:
      slot_storage = component
  
  if slot_storage == null:
    return false
  return slot_storage.storage.get(resource) > 0

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
    var max_amount: int = 0
    var amount_in_stock: int = 0
    var amount_needed: int = 0

    if sized_storage != null:
      max_amount = sized_storage.storage_capacity
      amount_in_stock = sized_storage.storage.get(resource)
    elif slot_storage != null:
      max_amount = slot_storage.max_capacity.get(resource, 0)
      amount_in_stock = slot_storage.storage.get(resource, 0)
    
    amount_needed = max_amount - amount_in_stock
    needed_resources[resource] = amount_needed

  var needed_resources_sorted: Array[StringName] = needed_resources.keys()
  needed_resources_sorted.sort_custom(func(a, b): return needed_resources[a] > needed_resources[b])

  return needed_resources.keys()

func unload_resources(resource: StringName, amount: int) -> void:
  var storage_component: Storage = null
  for component in self.get_children():
    if component is Storage:
      storage_component = component
      break
  
  var amount_in_storage: int = storage_component.storage.get(resource)
  storage_component.set_storage_item_amount(resource, amount_in_storage + amount)

func load_resources(resource: StringName, amount: int) -> int:
  var storage_component: Storage = null
  for component in self.get_children():
    if component is Storage:
      storage_component = component
      break

  var available_amount: int = storage_component.storage.get(resource)
  var amount_to_load: int = min(amount, available_amount)
  storage_component.set_storage_item_amount(resource, available_amount - amount_to_load)

  return amount_to_load
