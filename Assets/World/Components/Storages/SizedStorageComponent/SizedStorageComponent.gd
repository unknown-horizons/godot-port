extends StorageComponent

class_name SizedStorageComponent

@export var storage_capacity: int = 10

func set_storage_item_amount(resource: StringName, new_amount: int):
  self.storage[resource] = clamp(new_amount, 0, storage_capacity)
  self.storage_changed.emit()
