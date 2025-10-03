extends WorldThing2D

class_name BaseComponent

@export var paused: bool = false: set = set_pause

signal unpaused

func set_pause(value: bool) -> void:
  paused = value
  if self.paused == false:
    unpaused.emit()

## Default function to let the component know about neighboring components
func set_components(_new_components: Array[BaseComponent]) -> void:
  pass