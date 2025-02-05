@tool
extends TabWidget
class_name BuildingMenuTabWidget

## The objects currently selected.
var selected_objects: Array = []: set = set_selected_objects

## This function is called when the selected_objects is set,
## and the function is to be overridden
func set_selected_objects(new_selected_objects: Array):
  selected_objects = new_selected_objects
