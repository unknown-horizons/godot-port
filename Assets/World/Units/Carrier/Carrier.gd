extends Unit2D

class_name Carrier
#enum animation_ints {
  #0   = 0,
  #45  = 1,
  #90  = 2,
  #135 = 3,
  #180 = 4,
  #
#}

var object_carring: String
var count_of_objects: int



func _ready():
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

  await self.get_parent().resource_produced

# if we dont have a path, continue waiting
  if len(path) <= 0:
    await wait_for_resources()

func load_resources_from_building():
  var object_data = await self.get_parent().load_carrier()
  object_carring = object_data[1]
  count_of_objects = object_data[0]

func move_to_warehouse():
# for safety
  if object_carring == "" or count_of_objects <= 0:
    return
  if len(path) > 0 and not is_moving and max_carry_limit >= count_of_objects:
    #person_sprite.play()
    cur_path = path.duplicate()
    cur_path.pop_front()
    is_moving = true
    self.visible = true
    await self.move(CarrierState.WithFreight)

func load_and_unload_at_warehouse():
  self.visible = false
  var building = self.get_parent().get_parent().building_pos_to_building.get(self.global_position)
  if building != null:
    count_of_objects = await building.unload_worker(object_carring, count_of_objects)
    var resources_needed = self.get_parent().get_resourses_needed()
    if resources_needed[0] != "":
      object_carring = resources_needed[0]
      count_of_objects = await building.load_worker(resources_needed[0], resources_needed[1])

func move_back():
  #person_sprite.play()
  self.visible = true
  cur_path = path.duplicate()
  cur_path.pop_back()
  cur_path.reverse()
  
  await self.move(CarrierState.Empty)
  count_of_objects = await self.get_parent().unload_carrier(object_carring, count_of_objects)
  #count_of_objects = 0
  is_moving = false
  self.visible = false
