extends Building2D

class_name Warehouse2D

@export var load_and_unload_time: float = 2
@export var max_loading_and_unloading_limit: int = 2

@onready var LoadUnloadTimer: Timer = get_node("LoadUnloadTimer")

signal slot_opened

var cur_loading_and_unloading: int = 0

func load_unload_worker(unload_objects: Dictionary, load_objects: Dictionary) -> Dictionary:
  # acquired load/unload lock
  while cur_loading_and_unloading >= max_loading_and_unloading_limit:
    await self.slot_opened
  cur_loading_and_unloading += 1
  # load and unload worker
  await unload_worker(unload_objects)
  var objects_to_load = await load_worker(load_objects)
  # finish loading and unloading
  cur_loading_and_unloading -= 1
  slot_opened.emit()

  return objects_to_load

func unload_worker(objects_to_unload: Dictionary) -> void:
  # if no request on unloading
  if objects_to_unload == {}:
    return
  await self.get_tree().create_timer(load_and_unload_time / 2).timeout
  # for future multi loads if any, wraped in for loop
  for object: ItemData in objects_to_unload.keys():
    var amount = objects_to_unload.get(object)
    if GameStats.game_stats_resource.resources.has(object):
      GameStats.game_stats_resource.resources[object] += amount
    else:
      GameStats.game_stats_resource.resources[object] = amount
    #update_resources.emit()
    print("the amount of %s is now %s" % [object.game_name, GameStats.game_stats_resource.resources[object]])

func load_worker(objects_to_load: Dictionary) -> Dictionary:
  # if no request on loading
  if objects_to_load == {}:
    return {}
  await self.get_tree().create_timer(load_and_unload_time / 2).timeout
  var available_objects: Dictionary = {}
  for object in objects_to_load.keys():
    var amount = objects_to_load.get(object)
    if amount != null:
      if not GameStats.game_stats_resource.resources.has(object):
        continue
      var max_available: int = min(amount, GameStats.game_stats_resource.resources[object])
      GameStats.game_stats_resource.resources[object] -= max_available
      available_objects[object] = max_available
      print("the amount of %s is now %s" % [object.game_name, GameStats.game_stats_resource.resources[object]])
  return available_objects
