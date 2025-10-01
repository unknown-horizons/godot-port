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

@onready var parent_building: Building2D2 = self.get_parent()

var objects_carrying: Dictionary[StringName, int] = {}

func start_working():
  movement_loop()

func is_resource_load_valid() -> bool:
  for resource in self.objects_carrying.keys():
    if self.objects_carrying[resource] > max_carry_limit:
      return false
  return true

func is_carrier_full() -> bool:
  return self.objects_carrying.keys().any(func(resource): return self.objects_carrying[resource] > 0)

func movement_loop():
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
      if parent_building.number_of_output_products > 0:
        return
      if not parent_building.is_storage_full():
        if parent_building.building_data.input_products.keys().any(func (resource): return GameStats.game_stats_resource.resources[resource] > 0):
          return
    await self.get_tree().create_timer(1).timeout

func load_resources_from_building():
  self.objects_carrying = await parent_building.load_carrier()
  # raise error if objects carring is invalid
  if not is_resource_load_valid():
    push_error("Invalid resource load: %s" % [self.objects_carrying])

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
    if self.is_carrier_full():
      await self.move("MoveFull", self.path_there)
    else:
      await self.move("Move", self.path_there)

func load_and_unload_at_warehouse():
  self.visible = false
  var building = parent_building.built_tilemap.building_position_to_building.get(self.global_position)
  if building != null and building is Warehouse2D2:
    if building.max_loading_and_unloading_limit <= building.cur_loading_and_unloading:
      await building.slot_opened
    var resources_to_load: Dictionary[StringName, int] = parent_building.get_resourses_needed()
    self.objects_carrying = await building.load_unload_worker(self.objects_carrying, resources_to_load)
  # raise error if objects carring is invalid
  if not is_resource_load_valid():
    push_error("Invalid resource load: %s" % [self.objects_carrying])

func move_back():
  if self.is_carrier_full():
    await self.move("MoveFull", self.path_back)
  else:
    await self.move("Move", self.path_back)
  self.objects_carrying = await parent_building.unload_carrier(self.objects_carrying)
  # raise error if objects carring is invalid to know if there is a bug
  if not is_resource_load_valid():
    push_error("Invalid resource load: %s" % [self.objects_carrying])
  is_moving = false
  self.visible = false
