extends SelectionContext
class_name MovementContext

func move_selected_units(m_pos: Vector2) -> void:
	var result = _player_camera.raycast_from_mouse()
	if result:
		print_debug("Command: Move selected units {0} ".format([result]))
		for unit in _player_camera.selected_entities:
			if unit.faction == _player_camera.player.faction:
				unit.move_to(Utils.map_3_to_2(result.position))

func _on_ia_main_command_pressed(target: Node, position: Vector2) -> void:
	#print_debug("Move action")

	var m_pos = get_viewport().get_mouse_position()
	move_selected_units(m_pos)
