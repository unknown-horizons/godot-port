extends Node
class_name InteractionContext
# Template for different behavior states within the interaction system.
# It is meant to be inherited from and not to be instanced directly.
#
# PlayerCamera will keep track of one active InteractionContext at a time
# and will pass any unhandled InputEvents to it.
# E.g., a build menu could invoke a switch to its own InteractionContext
# to handle the display of ghost buildings and later the placement of actual buildings.
# If a military unit is selected, the system could swap to an InteractionContext
# responsible for military commands, etc.
#
# Each InteractionContext is responsible for setting inputs
# as handled themselves if so desired.
#
# Per default, any InteractionContext can emit two different signals:
#	switch_context - This signal causes the interaction system to switch its
#					 active InteractionContext to the one provided as parameter.
#	abort_context - This signal causes the interaction system to revert to the
#					default context (probably selection mode)
#
# The PoolStringArray 'valid_actions' contains the names of all possible
# action names. These are the same names as they would be used with
# InputEvent.is_action().
# Each of these actions will be routed to a method identified by its name.
# The method should be constructed as follows:
#	func _on_ia_<action name>_<pressed|released>(
#		target: Node,
#		position: Vector3
#		) -> void
#
# Spaces in the action name will be replaced by underscores
# ('action name' will become _on_ia_action_name_pressed()
#  or _on_ia_action_name_released())
#
# A notable exception to this is the method:
#	func _on_mouse_motion(
#		event: InputEventMouseMotion,
#		target: Node,
#		position: Vector3
#		) -> void
#
# All InputEventMouseMotion events will be routed to this function. This can
# be used to update hover effects, the cursor, etc.

signal switch_context
signal abort_context

onready var _parent := get_parent()

export(String) var _context_name = "Basic Interaction Context"
export(PoolStringArray) var valid_actions = ["main_command"]

func interact(event: InputEvent, target: Node, position: Vector3) -> void:
	if event.is_action_type():
		for action in valid_actions:
			if event.is_action(action):
				var function: String = make_function_name(
					action, event.is_action_pressed(action))
				if self.has_method(function):
					self.call(function, target, position)
					return
	elif event is InputEventMouseMotion:
		_on_mouse_motion(event, target, position)
		return

func make_function_name(action: String, pressed: bool = true) -> String:
	var func_name: String = action.replace(" ", "_")
	func_name = "_on_ia_" + func_name
	if pressed:
		func_name += "_pressed"
	else:
		func_name += "_released"
	return func_name

func get_valid_actions() -> PoolStringArray:
	return valid_actions

func _on_enter() -> void:
	print_debug("InteractionContext %s entered" % _context_name)

func _on_exit() -> void:
	print_debug("InteractionContext %s left" % _context_name)

func _on_mouse_motion(event: InputEventMouseMotion, target: Node, position: Vector3) -> void:
	pass

func _on_ia_main_command_pressed(target: Node, position: Vector3) -> void:
	emit_signal("abort_context")
	get_tree().set_input_as_handled()
