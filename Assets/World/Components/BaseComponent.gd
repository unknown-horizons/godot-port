extends WorldThing2D

class_name BaseComponent

@export var paused: bool = true: set = set_pause

signal unpaused

func _ready() -> void:
  var child_components: Array[BaseComponent] = []
  for child in self.get_children():
    var component := child as BaseComponent
    if component != null:
      child_components.append(component)

  for component in child_components:
    component.set_components(child_components)

func set_pause(value: bool) -> void:
  paused = value
  for child in self.get_children():
    var component := child as BaseComponent
    if component != null:
      component.paused = self.paused
  if self.paused == false:
    unpaused.emit()

## unpause the component if allowed
func unpause_if_can():
  self.paused = false

## Default function to let the component know about neighboring components
func set_components(_new_components: Array[BaseComponent]) -> void:
  pass
