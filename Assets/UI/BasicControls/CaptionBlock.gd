@tool
extends VBoxContainer
class_name CaptionBlock

@export var text: String = "This is a Book Title":
	set(new_text):
		if not is_inside_tree():
			await self.ready

		text = new_text

		caption.text = text

## How far the top margin should be when the control is appended below a
## sibling control.
@export var margin_top_as_sub: int = 4:
	set(new_margin):
		margin_top_as_sub = new_margin
		_update_top_margin()

@onready var caption := $Caption

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PRE_SORT_CHILDREN:
			_update_top_margin()

func _update_top_margin() -> void:
	if get_index() > 0:
		%HSeparator.add_theme_constant_override("separation", margin_top_as_sub)
	else:
		%HSeparator.remove_theme_constant_override("separation")
