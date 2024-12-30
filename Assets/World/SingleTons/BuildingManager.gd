extends Node
#
#var Farm2D = preload("res://Assets/World/Buildings/Agricultural/Farm2D/Farm2D.tscn")
#var WareHouse = preload("res://Assets/World/Buildings/WareHouse2D/ware_house2D.tscn")
var building_data: Dictionary = {
"farm": {"cost": {"Timber": 1}},
"warehouse": {"cost": {}},
"cattle_run": {"cost": {"Timber": 1}},
"lumberjack_tent": {"cost": {}},
"road": {"cost": {}}
}

var building_to_build = null

const road = "road"


func set_building_to_build(building):
  building_to_build = building

func has_resources_for_building(building_name: String = building_to_build) -> bool:
  var building_cost: Dictionary = building_data[building_to_build]["cost"]
  for resource in building_cost.keys():
    var amount_needed: int = building_cost[resource]
    var amount_available = GameStats.game_stats_resource.resources.get(resource)
    var can_be_built: bool = amount_available != null and amount_needed <= amount_available
    if not can_be_built:
      # in the future, tell the player the needed resources
      return false

  return true

func spend_resources_for_building(building_name: String = building_to_build) -> void:
  var building_cost: Dictionary = building_data[building_to_build]["cost"]
  for resource in building_cost.keys():
    var amount_needed: int = building_cost[resource]
    GameStats.game_stats_resource.resources[resource] -= amount_needed
    print("the amount of %s is now %s" % [resource, GameStats.game_stats_resource.resources[resource]])
