extends AnimatableBody2D

class_name Person

@export var max_carry_limit: int = 10
@export var speed_tile_per_sec: float = 0.5

#@onready var tile_map: TileMapLayer = get_node("../Builded")
@onready var MoveTimer: Timer = get_node("MoveTimer")

var path: Array = []
var path_left: Array = []

var objects_carring: Dictionary = {"to_warehouse": ["", 0], "back": null}
var object_carring: String
var count_of_objects: int

var is_moving: bool = false



func _ready():
  objects_carring["to_warehouse"][1] = min(objects_carring.get("to_warehouse")[1], max_carry_limit)
  if objects_carring.get("back") != null:
    objects_carring["back"] = min(objects_carring.get("back")[1], max_carry_limit)
  wait_for_resources()



func wait_for_resources():
  objects_carring = await self.get_parent().resource_availble

  object_carring = objects_carring.get("to_warehouse")[0]
  count_of_objects = await self.get_parent().load_person(objects_carring.get("to_warehouse")[1])
  
  move_to_warehouse()



func move_to_warehouse():

# for safety
  if object_carring == "" or count_of_objects <= 0:
    return

  if len(path) > 0 and not is_moving and max_carry_limit >= count_of_objects:

    path_left = path.duplicate()
    path_left.pop_front()
    is_moving = true
    self.visible = true

    await move()

    load_unload_at_warehouse()



# 64, -32
# -196, 256
func load_unload_at_warehouse():

  var building = self.get_parent().get_parent().building_pos_to_building.get(self.position)
  if building != null:

    await building.unload_person(count_of_objects, object_carring)

    var objects_carring_back = objects_carring.get("back")
    if objects_carring_back != null:
      object_carring = objects_carring_back[0]
      count_of_objects = await building.load_person(object_carring, objects_carring_back[1])
      move_back()
    
    #LoadUnloadTimer.start(load_unload_time)
    #await LoadUnloadTimer.timeout
#
    #building.unload_person(count_of_objects, object_carring)
    #count_of_objects = 0
#
    #LoadUnloadTimer.start(load_unload_time)
    #await LoadUnloadTimer.timeout



func move_back():
  path_left = path.duplicate()
  path_left.pop_back()
  path_left.reverse()
  await move()
  self.get_parent().unload_person(object_carring, count_of_objects)
  await self.get_parent().unload_person()
  count_of_objects = 0
  wait_for_resources()



func move():

  #var tile_layer_pos
  var global_pos
  # var next_tile_pos

  MoveTimer.start(speed_tile_per_sec)

  while len(path_left) > 0:

    await MoveTimer.timeout

    global_pos = path_left.pop_front()
    #next_tile_pos = tile_layer_pos - self.get_parent().position
    self.global_position = global_pos
    #self.set_global_position(global_pos)
  
  print(self.global_position)
  MoveTimer.stop()



#func _on_LoadUnloadTimer_timeout():
  #var building = self.get_parent().get_parent().building_pos_to_building.get(self.position)
  #MoveTimer.stop()
  #
  #if building != null:
    #if building.game_name == "WareHouse":
#
      #building.unload_person(count_of_objects, object_carring)
      #count_of_objects = 0
#
    #if building.game_name == self.get_parent().game_name:
      #self.visible = false
      #is_moving = false
      #building.number_of_intake_products += count_of_objects
      #count_of_objects = 0
