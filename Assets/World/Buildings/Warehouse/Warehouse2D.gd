extends Building2D

class_name Warehouse2D

signal slot_opened

@export var storage_capacity: int = 100
@export var load_or_unload_time: float = 1
@export var max_loading_and_unloading_units: int = 2

var units_loading: int = 0

func is_resource_available(resource: StringName) -> bool:
  return GameStats.game_stats_resource.resources.get(resource, 0) > 0

func unload_resource(resource: StringName, amount: int) -> void:
  while units_loading >= max_loading_and_unloading_units:
    await self.slot_opened

  units_loading += 1
  await self.sleep(load_or_unload_time)
  GameStats.game_stats_resource.add_resource(resource, amount)
  units_loading -= 1
  slot_opened.emit()

func load_resource(resource: StringName, amount: int) -> int:
  while units_loading >= max_loading_and_unloading_units:
    await self.slot_opened

  units_loading += 1
  self.sleep(load_or_unload_time)
  var available_amount: int = GameStats.game_stats_resource.resources.get(resource, 0)
  var amount_to_load: int = clamp(amount, 0, available_amount)
  GameStats.game_stats_resource.add_resource(resource, -amount_to_load)

  units_loading -= 1
  slot_opened.emit()
  return amount_to_load


  
