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
#
#var Farm2D = preload("res://Assets/World/Buildings/Agricultural/Farm2D/Farm2D.tscn")
#var WareHouse = preload("res://Assets/World/Buildings/WareHouse2D/ware_house2D.tscn")

const road = "road"

enum Buildings {
  farm =       1,
  warehouse =  2,
  cattle_run = 3,
  lumberjack = 4,
}

func _input(event: InputEvent) -> void:
  var build_building_name := ""

  if event.is_action_pressed("toggle_build_building"):
    build_building_name = event.get_meta("building_name")
    if build_building_name == null or build_building_name== "":
      push_error("`toggle_build_building` action is pressed, but `building_name` meta is null or empty.")

  if event.is_action_pressed("toggle_build_road"):
    build_building_name = "road"
    
  if build_building_name:
    print_debug(event, ", building_name: ", build_building_name);
    if (build_building_name != null):
      set_building_to_build(build_building_name)


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
