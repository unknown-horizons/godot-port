extends Label

@export var float_time: float = 2
@export var height_of_float: int = 32



func start_showing(item_name: String, amount: int):
  self.visible = true
  self.text = "%s %s" % [item_name, amount]

  var initial_pos = self.position

  var float_tween = self.create_tween().bind_node(self)
  float_tween.tween_property(self, "position", Vector2(self.position.x, self.position.y - height_of_float), float_time)

  #var fade_tween = self.create_tween().bind_node(self)
  #float_tween.tween_property(self, "", float_time)

  await float_tween.finished

  float_tween.kill()

  self.visible = false
  self.position = initial_pos
