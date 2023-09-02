extends SelectionContext
class_name MovementContext

func move_selected_units_to(position) -> void:
	#print_debug("Command: Move selected units {0} ".format([result]))
	print("Command: Move selected units to ", position)
	for unit in _player_camera.selected_entities:
		if unit.faction == _player_camera.player.faction:
			#unit.move_to(round(Vector2(position.x + 0.5, position.y + 0.5)))
			#unit.move_to(Vector2(position.x + 1, position.y + 1))
			unit.move_to(Vector2(position))

func _on_ia_main_command_pressed(target: Node, position: Vector2) -> void:
	#print_debug("Move action")
	if not target is AStarMap:
		print(target) # TODO: Interact with different entity (e.g. attack)
	else:
		move_selected_units_to(position)
