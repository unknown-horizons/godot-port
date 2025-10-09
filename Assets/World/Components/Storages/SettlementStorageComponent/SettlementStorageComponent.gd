extends StorageComponent

class_name SettlementStorageComponent

func get_storage_item_amount(resource: StringName) -> int:
  return GameStats.game_stats_resource.resources.get(resource, 0)
