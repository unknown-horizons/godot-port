extends Node

class_name BaseContext

## Defines if the context is active.
var is_active: bool = false

## Called when the context enters the active state.
## Override this method to do something at the activation of the context.
func context_entered() -> void:
  print(self.name + " entered")

## Called when the context exits the active state.
## Override this method to do something at the deactivation of the context.
func context_exited() -> void:
  print(self.name + " exited")
