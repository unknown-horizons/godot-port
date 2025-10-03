extends BaseComponent

class_name StorageComponent

@export var load_or_unload_time: float = 2.0

## The storage of the building.[br]
## [b]Note[/b]: The [method SlotStorageComponent.set_storage_item_amount] function is to be used to set a key
var storage: Dictionary[StringName, int] = {} # Resource to count map

## emited when the storage changes
signal storage_changed

## Used to set the storage amount of a specific resource.[br]
## The resource key will be created if it does not exist in the storage.[br]
func set_storage_item_amount(resource: StringName, new_amount: int):
  storage[resource] = max(new_amount, 0)
  storage_changed.emit()
