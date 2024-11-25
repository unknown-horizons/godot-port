extends AnimatableBody2D

class_name Unit2D

@export var max_carry_limit: int = 10
@export var speed_tile_per_sec: float = 0.5

@onready var person_sprite: AnimatedSprite2D = self.get_child(0)

var path: Array = []
var cur_path: Array = []

var is_moving: bool = false



func get_animation_name(angle_of_walk: float, full: bool = true):
  if full:
    return "FullDeg%s" % [angle_of_walk]
  else:
    return "Deg%s" % [angle_of_walk]



func get_sprite_angle(next_point: Vector2, is_full: bool):
  var move_vec: Vector2 = next_point - self.global_position
  var move_angle = move_vec.angle_to(Vector2(1, 0))
  # calc the sprite angle:
  var move_angle_0_to_2PI = fposmod(move_angle, 2 * PI)
  var move_angle_0_to_8 = move_angle_0_to_2PI * 8 / (2 * PI)
  var sprite_angle = round(move_angle_0_to_8) * 45
  return sprite_angle



func move(is_full: bool = true):

  var last_direction = 0
  for point in cur_path:

    var sprite_angle = get_sprite_angle(point, is_full)
    if last_direction != sprite_angle:
      last_direction = sprite_angle
      person_sprite.play(get_animation_name(sprite_angle, is_full))

    #print(sprite_angle)
    var move_tween = self.create_tween().bind_node(self)
    move_tween.tween_property(self, "global_position", point, speed_tile_per_sec)
    await move_tween.finished
    #pass
    #move_tween.kill()
  
  self.global_position = cur_path[len(cur_path) - 1]
  await self.get_tree().create_timer(0.05).timeout # let the _process run once.
  person_sprite.stop()
