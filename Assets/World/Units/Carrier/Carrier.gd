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



func _ready():
  movment_loop()

func movment_loop():
  while true:
    await wait_for_resources()

    await load_resources_from_building()

    await move_to_warehouse()

    await load_and_unload_at_warehouse()

    await move_back()

func wait_for_resources():
  self.is_moving = false
  while true:

    await self.get_tree().create_timer(1).timeout

    if self.get_parent().number_of_output_products > 0:
      if len(self.path) > 0:
        return

func load_resources_from_building():
  var object_data = await self.get_parent().load_carrier()
  self.object_carring = object_data[1]
  self.count_of_objects = object_data[0]

func move_to_warehouse():
# for safety
  if self.object_carring == "" or self.count_of_objects <= 0:
    return
  if len(path) > 0 and not is_moving and max_carry_limit >= self.count_of_objects:
    #person_sprite.play()
# set path to and back to current known path
    path_there = path.duplicate()
    path_there.pop_front()
    path_back = path.duplicate()
    path_back.reverse()

    is_moving = true
    #self.visible = true
    await self.move(self.path_there)

func load_and_unload_at_warehouse():
  self.visible = false
  var building = self.get_parent().get_parent().building_pos_to_building.get(self.global_position)
  if building != null and building is Warehouse2D:
    var load_or_unload_time = building.load_and_unload_time / 2
    if building.max_loading_and_unloading_limit <= building.cur_loading_and_unloading:
      await building.slot_opened

    #building.loading_started()
    #await self.get_tree().create_timer(load_or_unload_time).timeout
    #self.count_of_objects = building.unload_worker(self.object_carring, self.count_of_objects)
    var resources_needed = self.get_parent().get_resourses_needed()
    var resourses_to_unload: Dictionary = {self.object_carring: self.count_of_objects}
    var resourses_to_load: Dictionary = {"": 0}

    if resources_needed[0] != "":
      resourses_to_load = resources_needed
    var resoursece_to_carry_back: Dictionary = await building.load_unload_worker(resourses_to_unload, resourses_to_load)
    self.object_carring = resoursece_to_carry_back.keys()[0]
    self.count_of_objects = resoursece_to_carry_back.get(self.object_carring)
      #self.object_carring = resources_needed[0]
      #await self.get_tree().create_timer(load_or_unload_time).timeout
      #self.count_of_objects = building.load_worker(resources_needed[0], resources_needed[1])
    #building.loading_finished()

func move_back():
  #person_sprite.play()
  await self.move(self.path_back)
  self.count_of_objects = await self.get_parent().unload_carrier(self.object_carring, self.count_of_objects)
  #self.count_of_objects = 0
  is_moving = false
