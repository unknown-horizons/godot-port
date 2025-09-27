extends TileMapLayer

class_name RoadAndBuildingHighlighter

var highlighted_objects: Array = []

signal new_building_added(new_building: Building2D2)

func _on_child_entered_tree(node):
  if node is Building2D2:
    highlighted_objects.append(node)
    new_building_added.emit(node)

func _on_child_exiting_tree(node):
  if node is Building2D2:
    highlighted_objects.erase(node)
