extends Node2D

class_name WorldThing2D

enum StorageStates {
  EMPTY = 0,
  FULL  = 1,
}

enum ActionStates {
  IDLE = 0,
  MOVE = 1,
  WORK = 2
}

enum Orientations {
  _000 = 0,
  _045 = 45,
  _090 = 90,
  _135 = 135,
  _180 = 180,
  _225 = 225,
  _270 = 270,
  _315 = 315
}

signal cancel_sleep

func binary_insert(sorted_list: Array, value, key: Callable = func(a, b): return a < b):
  var low := 0
  var high := sorted_list.size()

  while low < high:
    var mid := int((low + high) / 2)
    if key.call(sorted_list[mid], value):
      low = mid + 1
    else:
      high = mid

  # Insert the value at the correct index
  sorted_list.insert(low, value)

## Returns all the components of the certain type
func get_all_nodes_of_type(component_type: Variant) -> Array[WorldThing2D]:
  var components: Array[WorldThing2D] = []
  for component in self.get_children():
    if is_instance_of(component, component_type):
      components.append(component)
  return components

## Returns the first component of the certain type
func get_first_node_of_type(component_type: Variant) -> WorldThing2D:
  for component in self.get_children():
    if is_instance_of(component, component_type):
      return component
  return null

## To be overridden for functionality on inputs when the building is selected
func handle_context_input(event: InputEvent):
  for child in self.get_children():
    var world_thing := child as WorldThing2D
    if world_thing != null:
      world_thing.handle_context_input(event)

## To be overridden for functionality when the building is selected
func selected(_is_now_selected: bool) -> void:
  pass

## ends after a given amount of time, returns true if successful
func sleep(time: float) -> bool:
  if self.is_inside_tree() == false:
    return false
  var timer := self.get_tree().create_timer(time)
  self.cancel_sleep.connect(timer.timeout.emit)
  await timer.timeout
  self.cancel_sleep.disconnect(timer.timeout.emit)
  return timer.time_left == 0
