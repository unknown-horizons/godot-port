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
func handle_context_input(_event: InputEvent):
  pass

## To be overridden for functionality when the building is selected
func selected(_is_now_selected: bool) -> void:
  pass


## ends after a given amount of time
func sleep(time: float) -> void:
  await self.get_tree().create_timer(time).timeout
