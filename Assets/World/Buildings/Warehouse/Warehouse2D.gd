extends Node2D

class_name Warehouse2D

@export_category("WareHouse")
@export var game_name: String = "WareHouse"
@export var load_and_unload_time: float = 2

@onready var LoadUnloadTimer: Timer = get_node("LoadUnloadTimer")

#signal update_resources


func _ready():
  self.get_parent().register_building(self)



func unload_person(object: String, amount: int) -> int:
  LoadUnloadTimer.start(load_and_unload_time / 2)
  await LoadUnloadTimer.timeout

  if GameStats.game_stats_resource.resources.has(object):
    GameStats.game_stats_resource.resources[object] += amount
  else:
    GameStats.game_stats_resource.resources[object] = amount

  #update_resources.emit()
  print("the amount of %s is %s" % [object, GameStats.game_stats_resource.resources[object]])

  return 0



func load_person(object: String, amount: int) -> int:
  LoadUnloadTimer.start(load_and_unload_time / 2)
  await LoadUnloadTimer.timeout

  if GameStats.game_stats_resource.resources.has(object):
    var max_available = min(amount, GameStats.game_stats_resource.resources[object])
    GameStats.game_stats_resource.resources[object] -= max_available
    #update_resources.emit()
    print("the amount of %s is %s" % [object, GameStats.game_stats_resource.resources[object]])
    return max_available
  else:
    print("the amount of %s is %s" % [object, GameStats.game_stats_resource.resources[object]])
    return 0
