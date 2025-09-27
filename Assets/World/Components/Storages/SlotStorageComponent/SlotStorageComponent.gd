extends StorageComponent
## The slot storage component is used in buildings to store resources
##
## The slot storage component is a components storing resources in different slots below a certain amount

class_name SlotStorageComponent

## The capacity of the storage slots.
@export var max_capacity: Dictionary[ResourceConfig.Resources, int] = {}

func _ready():
  # check if the max_capacity and storage dictionary is in the right format and have all the nessesary keys in the storage
  for resource in max_capacity.keys():
    if storage.has(resource) == false: # if the resource is not in the storage add it
      storage[resource] = 0
  set_storage_item_amount(ResourceConfig.Resources.FLOUR, 2)

## Used to set the storage amount of a specific resource.[br]
## The resource key will be created if it does not exist in the storage.[br]
func set_storage_item_amount(resource: ResourceConfig.Resources, new_amount: int):
  var max_amount: int = max_capacity.get(resource)
  if max_amount != null:
    self.storage[resource] = clamp(new_amount, 0, max_amount)
  else:
    self.storage[resource] = new_amount
    push_warning("The resource %s does not have a max capacity" % resource)
  self.storage_changed.emit()
