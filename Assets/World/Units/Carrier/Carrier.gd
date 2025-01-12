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
@export var max_carry_limit: int = 10

var objects_carring: Dictionary

func _ready():
  movment_loop()

func is_resource_load_valid() -> bool:
  for resource in objects_carring.keys():
    if objects_carring[resource] > max_carry_limit:
      return false
  return true

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
    if len(self.path) > 0:
      if self.get_parent().number_of_output_products > 0:
        return
      if not self.get_parent().is_storage_full():
        return
    await self.get_tree().create_timer(1).timeout

func load_resources_from_building():
  objects_carring = await self.get_parent().load_carrier()
  # raise error if objects carring is invalid
  if not is_resource_load_valid():
    push_error("Invalid resource load: %s" % [objects_carring])

func move_to_warehouse():
  # make sure that object carring data if valid
  if len(path) > 0 and not is_moving and is_resource_load_valid():
  # set path to and back to current known path
    path_there = path.duplicate()
    path_there.pop_front()
    path_back = path.duplicate()
    path_back.reverse()
    is_moving = true
    # find the correct animation prefix
    if objects_carring != {}:
      await self.move("MoveFull", self.path_there)
    else:
      await self.move("Move", self.path_there)

func load_and_unload_at_warehouse():
  self.visible = false
  var building = self.get_parent().get_parent().building_pos_to_building.get(self.global_position)
  if building != null and building is Warehouse2D:
    if building.max_loading_and_unloading_limit <= building.cur_loading_and_unloading:
      await building.slot_opened
    var resources_to_load: Dictionary = self.get_parent().get_resourses_needed()
    objects_carring = await building.load_unload_worker(objects_carring, resources_to_load)
  # raise error if objects carring is invalid
  if not is_resource_load_valid():
    push_error("Invalid resource load: %s" % [objects_carring])

func move_back():
  if objects_carring != {}:
    await self.move("MoveFull", self.path_back)
  else:
    await self.move("Move", self.path_back)
  objects_carring = await self.get_parent().unload_carrier(objects_carring)
  # raise error if objects carring is invalid to know if there is a bug
  if not is_resource_load_valid():
    push_error("Invalid resource load: %s" % [objects_carring])
  is_moving = false
