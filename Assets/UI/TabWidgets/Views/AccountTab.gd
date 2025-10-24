extends VBoxContainer

var selected_node: WorldThing2D = null:
  set(value):
    selected_node = value
    on_new_selected_node(value)

func on_new_selected_node(node: WorldThing2D) -> void:
  for child in self.get_children():
    if "selected_node" in child:
      child.selected_node = node

  var building_selected: Building2D = node as Building2D
  if building_selected != null:
    # TODO: update happiness value
    pass
