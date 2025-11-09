@tool

extends StorageComponent

class_name SizedStorageComponent

@export var limit: int = 10

func get_storage_state() -> StorageComponentStates:
  var storage_state: StorageComponentStates = StorageComponentStates.FULL
  if self.has_node(".."):
    var parent := self.get_parent() as WorldThing2D
    if parent == null:
      return StorageComponentStates.EMPTY
    
    var production_lines := parent.get_all_nodes_of_type(ProductionLineComponent) as Array[WorldThing2D]
    # for each resource produced, check if not full in storage
    for production_line in production_lines:
      for produces in production_line.produces.keys():
        var max_amount = self.limit
        var current_amount = storage.get(produces, 0)
        if current_amount < max_amount: # if any not full, then partially full, empty will be catched later
          storage_state = StorageComponentStates.PARTIALLY_FULL
    # set to empty if all resources are empty
    if self.storage.values().reduce(func(sum, amount): return sum + amount, 0) as int <= 0:
      storage_state = StorageComponentStates.EMPTY
  
  return storage_state

func get_storage_items() -> Array[StringName]:
  return ResourceConfig.Resources.keys()

func get_max_capacity(_resource: StringName) -> int:
  return self.limit

func set_storage_item_amount(resource: StringName, new_amount: int) -> void:
  self.storage[resource] = clamp(new_amount, 0, limit)
  if self.storage[resource] == 0:
    self.storage.erase(resource)
  var storage_state := self.get_storage_state()
  self.storage_changed.emit(storage_state)
  # GameStats.game_stats_resource.resources_changed.emit()
  if not self.get_tree().process_frame.is_connected(GameStats.game_stats_resource.resources_changed.emit):
    self.get_tree().process_frame.connect(GameStats.game_stats_resource.resources_changed.emit, CONNECT_ONE_SHOT)