@tool
extends VBoxContainer
class_name CaptionBlock

@onready var caption_label: LabelEx = $Caption

var selected_node: WorldThing2D = null:
  set(value):
    selected_node = value
    if self.caption_label != null && selected_node != null:
      self.caption_label.text = selected_node.game_name

## How far the top margin should be when the control is appended below a
## sibling control.
@export var margin_top_as_sub: int = 4:
  set(new_margin):
    margin_top_as_sub = new_margin
    _update_top_margin()

func _notification(what: int) -> void:
  match what:
    NOTIFICATION_PRE_SORT_CHILDREN:
      _update_top_margin()

func _update_top_margin() -> void:
  if get_index() > 0:
    %HSeparator.add_theme_constant_override("separation", margin_top_as_sub)
  else:
    %HSeparator.remove_theme_constant_override("separation")
