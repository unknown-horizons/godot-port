@tool
extends LineEdit

## Single-line input field.

const ALIGN = {
	"Left": HORIZONTAL_ALIGNMENT_LEFT,
	"Center": HORIZONTAL_ALIGNMENT_CENTER,
	"Right": HORIZONTAL_ALIGNMENT_RIGHT
}

@export_enum("Left", "Center", "Right") var align_style := "Center" : set = set_align_style

var _current_editable

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		if _current_editable != editable:
			selecting_enabled = editable
			mouse_default_cursor_shape = CURSOR_IBEAM if editable else CURSOR_ARROW

			_current_editable = editable
			notify_property_list_changed()

func set_align_style(new_align_style: String) -> void:
	align_style = new_align_style

	# Text alignment
	alignment = ALIGN[align_style]
#	add_theme_stylebox_override( # StyleBox alignment
#			"normal",
#			load(ProjectSettings.get_setting("gui/theme/custom")).get_stylebox(
#				"normal_" + align_style.to_lower() if align_style != "Center"
#				else
#				"normal",
#					"LineEdit"))

	# StyleBox alignment
	_apply_style("focus")
	_apply_style("normal")
	_apply_style("read_only")

	notify_property_list_changed()

func _apply_style(name: String) -> void:
	return # TODO: Review for Godot 4
	add_theme_stylebox_override(
			name,
			load(ProjectSettings.get_setting("gui/theme/custom")).get_stylebox(
				name + "_" + align_style.to_lower() if align_style != "Center"
				else
				name,
					"LineEdit"))
