extends Node
## manages the buildings in the game

## building data folder
const bdf = "res://Assets/World/Data/BuildingData/"

var building_data: Dictionary = {}
var building_to_build: BuildingData = null

func _ready():
#  convert a list of building data files to a dictionary
  var building_data_files = [
    preload(bdf + "FarmData.tres"),
    preload(bdf + "LumberjackData.tres"),
    preload(bdf + "RoadData.tres"),
    preload(bdf + "WarehouseData.tres")
  ]
  for building_data_file in building_data_files:
    building_data[building_data_file.game_name] = building_data_file

func set_building_to_build(building_name: String):
  building_to_build = building_data.get(building_name)

func has_resources_for_building(prod_building_data: BuildingData = building_to_build) -> bool:
  for resource: ItemData in prod_building_data.cost.keys():
    var amount_needed: int = prod_building_data.cost[resource]
    var amount_available = GameStats.game_stats_resource.resources.get(resource)
    var can_be_built: bool = amount_available != null and amount_needed <= amount_available
    if not can_be_built:
      # in the future, tell the player the needed resources
      return false

  return true

func spend_resources_for_building(prod_building_data: BuildingData = building_to_build) -> void:
  for resource: ItemData in prod_building_data.cost.keys():
    var amount_needed: int = prod_building_data.cost[resource]
    GameStats.game_stats_resource.resources[resource] -= amount_needed
    print("the amount of %s is now %s" % [resource.game_name, GameStats.game_stats_resource.resources[resource]])
