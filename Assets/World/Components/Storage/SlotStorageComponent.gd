extends BaseComponent
## The slot storage component is used in buildings to store resources
##
## The slot storage component is a components storing resources in different slots below a certain amount

class_name SlotStorageComponent

## The capacity of the storage slots.
@export var max_capacity: Dictionary[ResourceConfig.Resources, int] = {}

## The storage of the building.[br]
## [b]Note[/b]: The [method SlotStorageComponent.set_storage_item_amount] function is to be used to set a key
var storage: Dictionary[ResourceConfig.Resources, int] = {}:
  set(value): # for setting the the whole dictionary
    storage = value
    storage_changed.emit()

## emited when the storage changes
signal storage_changed

func _ready():
  # check if the max_capacity and storage dictionary is in the right format and have all the nessesary keys in the storage
  for resource in max_capacity.keys():
    if storage.has(resource) == false: # if the resource is not in the storage add it
      storage[resource] = 0

## Used to set the storage amount of a specific resource.[br]
## The resource key will be created if it does not exist in the storage.[br]
func set_storage_item_amount(resource: ResourceConfig.Resources, new_amount: int):
  var max_amount = max_capacity.get(resource)
  if max_amount != null:
    storage[resource] = min(new_amount, max_amount)
  else:
    storage[resource] = new_amount
    push_warning("The resource %s does not have a max capacity" % resource)
  storage_changed.emit()
