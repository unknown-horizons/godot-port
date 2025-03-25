extends Node2D

class_name WorldThing2D

## To be overridden for functionality on inputs when the building is selected
func handle_context_input(_event: InputEvent):
  pass

## To be overridden for functionality when the building is selected
func selected(_is_now_selected: bool) -> void:
  pass


## ends after a given amount of time
func sleep(time: float) -> void:
  await self.get_tree().create_timer(time).timeout
