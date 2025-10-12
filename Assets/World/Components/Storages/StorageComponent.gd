@tool

extends BaseComponent

class_name StorageComponent

enum StorageComponentStates {
  EMPTY          = 0,
  PARTIALLY_FULL = 1,
  FULL           = 2,
}

@export var load_or_unload_time: float = 2.0

## The storage of the building.[br]
## [b]Note[/b]: The [method SlotStorageComponent.set_storage_item_amount] function is to be used to set a key
@export var storage: Dictionary[StringName, int] = {} # Resource to count map

## a local signal emited when the storage changes
signal storage_changed(storage_state: StorageComponentStates)



func get_storage_state() -> StorageComponentStates:
  return StorageComponentStates.EMPTY

## Used to set the storage amount of a specific resource.[br]
## The resource key will be created if it does not exist in the storage.[br]
func set_storage_item_amount(resource: StringName, new_amount: int) -> void:
  storage[resource] = max(new_amount, 0)
  var storage_state: StorageComponentStates = self.get_storage_state()
  self.storage_changed.emit(storage_state)
  GameStats.game_stats_resource.resources_changed.emit()

func get_storage_item_amount(resource: StringName) -> int:
  return self.storage.get(resource, 0)
