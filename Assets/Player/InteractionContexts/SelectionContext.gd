extends InteractionContext

signal set_selection

export(int) var selection_tolerance = 10

var sel_pos_start: Vector3
var sel_pos_end: Vector3

func _on_ia_alt_command_pressed(target: Node, position: Vector3) -> void:
	# Start selection
	print_debug("Start selection")
	sel_pos_start = position
	_parent.set_sel_pos_start(position)
	_parent.show()

func _on_ia_alt_command_released(target: Node, position: Vector3) -> void:
	# End selection
	print_debug("End selection")
	sel_pos_end = position
	var selection: Array
	var top_left: Vector2 = get_viewport().get_camera().unproject_position(sel_pos_start)
	var bottom_right: Vector2 = get_viewport().get_camera().unproject_position(sel_pos_end)
	if top_left.distance_to(bottom_right) <= selection_tolerance:
		if target.is_in_group("units"):
			selection = [target]
	else:
		selection = get_selected_units(top_left, bottom_right)
	_parent.hide()
	emit_signal("set_selection", selection)

func _on_ia_main_command_pressed(target: Node, position: Vector3) -> void:
	# Abort selection
	print_debug("Abort selection")
	_parent.hide()

func get_selected_units(top_left: Vector2, bottom_right: Vector2) -> Array:
	if top_left.x > bottom_right.x:
		var tmp = top_left.x
		top_left.x = bottom_right.x
		bottom_right.x = tmp
	if top_left.y > bottom_right.y:
		var tmp = top_left.y
		top_left.y = bottom_right.y
		bottom_right.y = tmp
	var box = Rect2(top_left, bottom_right - top_left)
	var selected_units: Array = []
	for unit in get_tree().get_nodes_in_group("units"):
		if unit.faction == _parent.get_parent().player.faction:
			var u_pos := get_viewport().get_camera().unproject_position(unit.global_transform.origin)
			if box.has_point(u_pos):
				print_debug("Selected unit: %s" % unit)
				selected_units.append(unit)
	return selected_units

#func get_units_in_box(top_left: Vector2, bottom_right: Vector2) -> Array:
#	if top_left.x > bottom_right.x:
#		var tmp = top_left.x
#		top_left.x = bottom_right.x
#		bottom_right.x = tmp
#	if top_left.y > bottom_right.y:
#		var tmp = top_left.y
#		top_left.y = bottom_right.y
#		bottom_right.y = tmp
#	var box = Rect2(top_left, bottom_right - top_left)
#	var box_selected_units = []
#	for unit in get_tree().get_nodes_in_group("units"):
#		if unit.faction == _parent.player.faction and box.has_point(_parent._camera.unproject_position(unit.global_transform.origin)):
#			print_debug("Unit [{0}]".format([unit]))
#			box_selected_units.append(unit)
#	return box_selected_units
