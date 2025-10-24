extends VBoxContainer

@onready var caption_block := $CaptionBlock as CaptionBlock

var selected_node: WorldThing2D = null:
  set(value):
    selected_node = value
    on_new_selected_node(value)

func on_new_selected_node(node: WorldThing2D) -> void:
  for child in self.get_children():
    if "selected_node" in child:
      child.selected_node = node
