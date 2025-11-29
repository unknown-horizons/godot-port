extends StorageComponent

class_name SettlementStorageComponent

func get_storage_items() -> Array[StringName]:
  return GameStats.game_stats_resource.resources.keys()

func get_max_capacity(_resource: StringName) -> int:
  return 2**63 - 1 # int max

func set_storage_item_amount(resource: StringName, new_amount: int) -> void:
  GameStats.game_stats_resource.set_resource(resource, new_amount)
  #storage_changed.emit(StorageComponentStates.PARTIALLY_FULL) # not used anywhere (SettlementStorageComponent doesn't affect any ActoinSets)

func get_storage_item_amount(resource: StringName) -> int:
  return GameStats.game_stats_resource.resources.get(resource, 0)
