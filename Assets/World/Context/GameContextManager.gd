extends Node

class_name GameContextManager

@onready var selection_context: SelectionContext = self.get_node("SelectionContext")

## The current game context.
## When setted, calls exit_context on all contexts exept the context that is setted.
var current_context: BaseContext:
  get:
    return current_context
  set(value):
    if current_context:
      current_context.is_active = false
      current_context.context_exited()
    if value == null:
      value = selection_context
    if value:# value might be null if the selection_context is not loaded.
      value.is_active = true
      value.context_entered()
    current_context = value

func _ready():
  current_context = selection_context
