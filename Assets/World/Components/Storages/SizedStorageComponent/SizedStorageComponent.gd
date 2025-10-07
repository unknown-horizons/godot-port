extends StorageComponent

class_name SizedStorageComponent

@export var limit: int = 10

func set_storage_item_amount(resource: StringName, new_amount: int):
  self.storage[resource] = clamp(new_amount, 0, limit)
  self.storage_changed.emit()
