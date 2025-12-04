extends Node

class_name GameContextManager

@onready var selection_context: SelectionContext = self.get_node("SelectionContext")

signal context_changed(context: BaseContext)

## The current game context.
## When setted, calls exit_context on all contexts exept the context that is setted.
var current_context: BaseContext:
	get:
		return current_context
	set(value):
		var last_context := self.current_context
		current_context = value
		if last_context:
			last_context.is_active = false
			last_context.context_exited()
		if self.current_context == null:
			current_context = selection_context
		if self.current_context:# current_context might be null if the selection_context is not loaded.
			self.current_context.is_active = true
			self.current_context.context_entered()
		current_context = self.current_context
		self.context_changed.emit(self.current_context)

func _ready():
	current_context = selection_context
