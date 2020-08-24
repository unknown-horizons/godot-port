tool
extends LineEdit
# Single-line input field

const ALIGN = {
	"Left": LineEdit.ALIGN_LEFT,
	"Center": LineEdit.ALIGN_CENTER,
	"Right": LineEdit.ALIGN_RIGHT
}

export(String, "Left", "Center", "Right") var align_style := "Center" setget set_align_style

var _current_editable

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		if _current_editable != editable:
			selecting_enabled = editable
			mouse_default_cursor_shape = CURSOR_IBEAM if editable else CURSOR_ARROW

			_current_editable = editable
			property_list_changed_notify()

func set_align_style(new_align_style: String) -> void:
	align_style = new_align_style

	# Text alignment
	align = ALIGN[align_style]
#	add_stylebox_override( # StyleBox alignment
#			"normal",
#			theme.get_stylebox(
#				"normal_" + align_style.to_lower() if align_style != "Center"
#				else
#				"normal",
#					"LineEdit"))

	# StyleBox alignment
	_apply_style("focus")
	_apply_style("normal")
	_apply_style("read_only")

	property_list_changed_notify()

func _apply_style(name: String) -> void:
	add_stylebox_override(
			name,
			theme.get_stylebox(
				name + "_" + align_style.to_lower() if align_style != "Center"
				else
				name,
					"LineEdit"))
