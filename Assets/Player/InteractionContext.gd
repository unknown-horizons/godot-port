extends Node
class_name InteractionContext

## Template for different behavior states within the interaction system.
## It is meant to be inherited from and not to be instanced directly.
##
## [PlayerCamera] will keep track of one active [InteractionContext] at a time
## and will pass any unhandled [InputEvent]s to it.[br]
## E.g., a build menu could invoke a switch to its own interaction context object
## to handle the display of ghost buildings and later the placement of actual buildings.
## If a military unit is selected, the system could swap to a context
## responsible for military commands, etc.[br][br]
##
## Each interaction context is responsible for setting inputs
## as handled themselves if so desired.[br][br]
##
## Per default, any interaction context can emit two different signals:[br]
## [code]switch_context[/code] - This signal causes the interaction system to
## switch its active interaction context to the one provided as parameter.
## [code]context_aborted[/code] - This signal causes the interaction system to
## revert to the default context (probably selection mode).[br][br]
##
## The [PackedStringArray] [code]valid_actions[/code] contains the names of all possible
## action names. These are the same names as they would be used with
## [code]InputEvent.is_action()[/code].[br]
## Each of these actions will be routed to a method identified by its name.
## The method should be constructed as follows:
## [codeblock]
## func _on_ia_<action name>_<pressed|released>(
##      target: Node,
##      position: Vector2
## ) -> void
## [/codeblock][br]
##
## Spaces in the action name will be replaced by underscores, hence
## ...[code]action name[/code]... will become [code]_on_ia_action_name_pressed()[/code]
##  or [code]_on_ia_action_name_released()[/code].[br][br]
##
## A notable exception to that is the method:
## [codeblock]
##  func _on_mouse_motion(
##      target: Node,
##      position: Vector2
##  ) -> void
## [/codeblock][br]
## All InputEventMouseMotion events will be routed to this function. This can
## be used to update hover effects, the cursor, etc.

signal switch_context
signal context_aborted

@onready var _player_camera := owner as Node3D

@export var _context_name: String = "Basic Interaction Context"
@export var valid_actions: PackedStringArray = ["main_command", "alt_command"]

func interact(event: InputEvent, target: Node, position: Vector2) -> void:
	if event.is_action_type():
		for action in valid_actions:
			if event.is_action(action):
				var function: String = _make_function_name(
					action, event.is_action_pressed(action))
				if self.has_method(function):
					self.call(function, target, position)
					return
	elif event is InputEventMouseMotion:
		_on_mouse_motion(target, position)
		return

func abort_context() -> void:
	emit_signal("context_aborted")
	get_viewport().set_input_as_handled()

func _on_enter() -> void:
	pass#print("InteractionContext %s entered" % _context_name)

func _on_exit() -> void:
	pass#print("InteractionContext %s exited" % _context_name)

func _on_mouse_motion(target: Node, position: Vector2) -> void:
	pass

func _on_ia_main_command_pressed(target: Node, position: Vector2) -> void:
	abort_context()

func _make_function_name(action: String, pressed: bool = true) -> String:
	var func_name: String = action.replace(" ", "_")
	func_name = "_on_ia_" + func_name
	if pressed:
		func_name += "_pressed"
	else:
		func_name += "_released"
	return func_name
