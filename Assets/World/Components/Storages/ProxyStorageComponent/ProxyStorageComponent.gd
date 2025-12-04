extends StorageComponent
## A storage that uses the sibling-building's(building as sibling of storage) storage items
##
## This storage will redirect all of the storages functionality to the sibling-building's storage

class_name ProxyStorageComponent

## The storage being proxied(represented)
var proxied_storage: StorageComponent

func _ready() -> void:
	self.setup_proxy_storage() # fire and forget

func setup_proxy_storage():
	if self.paused:
		await self.unpaused
	for sibling in self.get_parent().get_children():
		var building: Building2D = sibling as Building2D
		if building != null:
			self.proxied_storage = building.get_first_node_of_type(StorageComponent)
		if self.proxied_storage != null:
			break
	if self.proxied_storage == null:
		push_error("Could not find storage to proxy")

func get_storage_state() -> StorageComponentStates:
	if self.proxied_storage == null:
		push_error("No storage to proxy")
		return StorageComponentStates.EMPTY
	return self.proxied_storage.get_storage_state()

func get_storage_items() -> Array[StringName]:
	if self.proxied_storage == null:
		push_error("No storage to proxy")
		return []
	return self.proxied_storage.get_storage_items()

func get_max_capacity(resource: StringName) -> int:
	if self.proxied_storage == null:
		push_error("No storage to proxy")
		return 0
	return self.proxied_storage.get_max_capacity(resource)

func set_storage_item_amount(resource: StringName, new_amount: int) -> void:
	if self.proxied_storage == null:
		push_error("No storage to proxy")
		return
	self.proxied_storage.set_storage_item_amount(resource, new_amount)
	var storage_state := self.proxied_storage.get_storage_state()
	self.storage_changed.emit(storage_state)

func get_storage_item_amount(resource: StringName) -> int:
	if self.proxied_storage == null:
		push_error("No storage to proxy")
		return 0
	return self.proxied_storage.get_storage_item_amount(resource)
