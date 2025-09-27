extends Building2D

class_name Warehouse2D

func is_resource_available(resource: ResourceConfig.Resources) -> bool:
  return GameStats.game_stats_resource.resources[resource] > 0

func unload_resources(resource: ResourceConfig.Resources, amount: int) -> void:
  GameStats.game_stats_resource.resources[resource] += amount

func load_resources(resource: ResourceConfig.Resources, amount: int) -> int:
  var available_amount: int = GameStats.game_stats_resource.resources[resource]
  var amount_to_load: int = clamp(amount, 0, available_amount)
  GameStats.game_stats_resource.resources[resource] -= amount_to_load

  return amount_to_load


  
