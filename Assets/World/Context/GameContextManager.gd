extends Node

class_name GameContextManager

## The current game context.
## When setted, calls exit_context on all contexts exept the context that is setted.
var current_context: BaseContext = null:
  get:
    return current_context
  set(value):
    if current_context:
      current_context.is_active = false
      current_context.context_exited()
    if value:
      value.is_active = true
      value.context_entered()
    current_context = value
