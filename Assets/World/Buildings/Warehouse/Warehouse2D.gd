extends Node2D

class_name Warehouse2D

@export_category("WareHouse")
@export var game_name: String = "WareHouse"
@export var load_and_unload_time: float = 2
@export var max_loading_and_unloading_limit: int = 2

@onready var LoadUnloadTimer: Timer = get_node("LoadUnloadTimer")

signal slot_opened

#signal update_resources
var cur_loading_and_unloading: int = 0



func _ready():
  self.get_parent().register_building(self)

#
#
#func loading_finished():
  #cur_loading_and_unloading = max(cur_loading_and_unloading - 1, 0)
  #slot_opened.emit()
#
#
#
#func loading_started():
  #cur_loading_and_unloading = min(cur_loading_and_unloading + 1, max_loading_and_unloading_limit)
#

func load_unload_worker(unload_quantity: Dictionary, load_quantity: Dictionary) -> Dictionary:
  # acquired load/unload lock
  while cur_loading_and_unloading >= max_loading_and_unloading_limit:
    await self.slot_opened
  cur_loading_and_unloading += 1

  # load and unload worker
  var load_worker_quantity: Dictionary = await unload_worker(unload_quantity)
  load_worker_quantity = await load_worker(load_quantity)

#  finish loading and unloading
  cur_loading_and_unloading -= 1
  slot_opened.emit()

  return load_worker_quantity



func unload_worker(unload_quantity: Dictionary) -> Dictionary:
# if no request on unloading
  if len(unload_quantity.keys()) <= 0 or unload_quantity == {"": 0}:
    return {"": 0}

  await self.get_tree().create_timer(load_and_unload_time / 2).timeout

# for future multi loads if any, code is wraped in a for loop
  for key in unload_quantity.keys():
    var object = key
    var amount = unload_quantity.get(key)
    if GameStats.game_stats_resource.resources.has(object):
      GameStats.game_stats_resource.resources[object] += amount
    else:
      GameStats.game_stats_resource.resources[object] = amount
    #update_resources.emit()
    print("the amount of %s is %s" % [object, GameStats.game_stats_resource.resources[object]])

  return {"": 0}

func load_worker(load_quantity: Dictionary) -> Dictionary:
# if no request on loading
  if len(load_quantity.keys()) <= 0 or load_quantity == {"": 0}:
    return {"": 0}

  await self.get_tree().create_timer(load_and_unload_time / 2).timeout

# for future multi loads if any, wraped in for loop
  for key in load_quantity.keys():
    var object = key
    var amount = load_quantity.get(key)
    if GameStats.game_stats_resource.resources.has(object):
      var max_available: int = min(amount, GameStats.game_stats_resource.resources[object])
      GameStats.game_stats_resource.resources[object] -= max_available
      #update_resources.emit()
      print("the amount of %s is %s" % [object, GameStats.game_stats_resource.resources[object]])
      return {object: amount}
    else:
      print("the amount of %s is %s" % [object, GameStats.game_stats_resource.resources[object]])
      return {"": 0}
  return {"": 0}
