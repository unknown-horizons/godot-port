extends InteractionContext
class_name SelectionContext

signal selected(new_selection: Array)
signal deselected

enum SelectionType {
	UNIT,
	BUILDING,
}

@onready var _parent := get_parent()

@export var selection_tolerance: int = 10

var sel_pos_start: Vector2
var sel_pos_end: Vector2

func get_selected_units(top_left: Vector2, bottom_right: Vector2) -> Array:
	if top_left.x > bottom_right.x:
		var tmp := top_left.x
		top_left.x = bottom_right.x
		bottom_right.x = tmp
	if top_left.y > bottom_right.y:
		var tmp := top_left.y
		top_left.y = bottom_right.y
		bottom_right.y = tmp
	var box = Rect2(top_left, bottom_right - top_left)
	var selected_units: Array = []
	for unit in get_tree().get_nodes_in_group("units"):
		if unit.faction == owner.player.faction:
			var unit_pos := get_viewport().get_camera_3d().unproject_position(unit.global_transform.origin)
			if box.has_point(unit_pos):
				print("Selected unit: %s" % unit.name)
				selected_units.append(unit)
	return selected_units

func _on_ia_alt_command_pressed(target: Node, position: Vector2) -> void:
	# Start selection
	print_debug("Start selection")
	sel_pos_start = position

	_parent.sel_pos_start = get_viewport().get_mouse_position()
	_parent.show()

func _on_ia_alt_command_released(target: Node, position: Vector2) -> void:
	# End selection
	print_debug("End selection")

	if not _parent.visible:
		return

	sel_pos_end = position
	var selection: Array
	var top_left: Vector2 = get_viewport().get_camera_3d().unproject_position(Utils.map_2_to_3(sel_pos_start))
	var bottom_right: Vector2 = get_viewport().get_camera_3d().unproject_position(Utils.map_2_to_3(sel_pos_end))
	if top_left.distance_to(bottom_right) <= selection_tolerance:
		if target != null and target is Unit or target is Building: #target.is_in_group("units"):
			selection = [target]
	else:
		selection = get_selected_units(top_left, bottom_right)
	_parent.hide()

	if selection:
		emit_signal("selected", selection)
	else:
		emit_signal("deselected")

func _on_ia_main_command_pressed(target: Node, position: Vector2) -> void:
	# Abort selection
	print_debug("Abort selection")
	_parent.hide()
