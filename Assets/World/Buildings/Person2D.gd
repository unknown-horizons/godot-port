extends AnimatableBody2D

class_name Person

@export var max_carry_limit: int = 10
@export var speed_tile_per_sec: float = 0.5

var path: Array = []
var cur_path: Array = []

var objects_carring: Dictionary = {"to_warehouse": ["", 0], "back": null}
var object_carring: String
var count_of_objects: int
var is_moving: bool = false



func _ready():
  objects_carring["to_warehouse"][1] = min(objects_carring.get("to_warehouse")[1], max_carry_limit)
  if objects_carring.get("back") != null:
    objects_carring["back"] = min(objects_carring.get("back")[1], max_carry_limit)
  do_movment_loop()



func do_movment_loop():
  await wait_for_resources()

  await load_resources_from_building()

  await move_to_warehouse()

  await load_and_unload_at_warehouse()

  await move_back()

  do_movment_loop()



func wait_for_resources():
  self.is_moving = false
  objects_carring = await self.get_parent().carry_resources
# if we dont have a path, continue waiting
  if len(path) <= 0:
    await wait_for_resources()



func load_resources_from_building():
  self.visible = true
  object_carring = objects_carring.get("to_warehouse")[0]
  count_of_objects = await self.get_parent().load_person(objects_carring.get("to_warehouse")[0], objects_carring.get("to_warehouse")[1])



func move_to_warehouse():

# for safety
  if object_carring == "" or count_of_objects <= 0:
    return

  if len(path) > 0 and not is_moving and max_carry_limit >= count_of_objects:

    cur_path = path.duplicate()
    cur_path.pop_front()
    is_moving = true
    self.visible = true

    await move()



func load_and_unload_at_warehouse():

  var building = self.get_parent().get_parent().building_pos_to_building.get(self.global_position)
  if building != null:

    count_of_objects = await building.unload_person(object_carring, count_of_objects)

    var objects_carring_back = objects_carring.get("back")
    if objects_carring_back != null:
      object_carring = objects_carring_back[0]
      count_of_objects = await building.load_person(object_carring, objects_carring_back[1])



func move_back():
  cur_path = path.duplicate()
  cur_path.pop_back()
  cur_path.reverse()
  await move()
  count_of_objects = await self.get_parent().unload_person(object_carring, count_of_objects)
  count_of_objects = 0
  is_moving = false



func move():

  for point in cur_path:

    var move_tween = self.create_tween().bind_node(self)
    move_tween.tween_property(self, "global_position", point, speed_tile_per_sec)
    await move_tween.finished
    pass
    #move_tween.kill()
  
  self.global_position = cur_path[len(cur_path) - 1]
  await self.get_tree().create_timer(0.05).timeout # let the _process run once.
