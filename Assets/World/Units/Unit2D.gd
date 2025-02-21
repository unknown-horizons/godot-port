extends WorldThing2D
## Inherited by all 2D game objects,

class_name Unit2D

@export var unit_data: UnitData = null
## The main sprite of the unit.
## If set to null, will set the first AnimatedSprite2D child found.
@export var unit_sprite: AnimatedSprite2D = null

var path: Array = []
var path_there: Array = []
var path_back: Array = []

var is_moving: bool = false

func _ready():
  self.setup_unit()

## Called when the unit should start working and is to be overridden
func start_working():
  pass

## set up the unit
func setup_unit():
  if unit_sprite == null:
    for child in self.get_children():
      if child is AnimatedSprite2D:
        unit_sprite = child
  if unit_sprite == null:
    push_warning("Unit2D: No person sprite found")

func get_sprite_angle(next_point: Vector2):
  var move_vec: Vector2 = next_point - self.global_position
  var move_angle = move_vec.angle_to(Vector2(1, 0))
  # calc the sprite angle:
  var move_angle_0_to_2PI = fposmod(move_angle, 2 * PI)
  var move_angle_0_to_8 = move_angle_0_to_2PI * 8 / (2 * PI)
  var sprite_angle = int(round(move_angle_0_to_8) * 45) % 360
  return sprite_angle

func move(animation_prefix: String, path: Array = path_there):
  # save the current states to restore them at the end of the function
  var last_visible_state = self.visible
  self.visible = true
  var last_move_state = self.is_moving
  self.is_moving = true
  if len(path) <= 0:
    return

  var last_direction = 0
  for point in path:
    if not is_moving:
      return
    var sprite_angle = get_sprite_angle(point)
    if last_direction != sprite_angle:
      last_direction = sprite_angle
      unit_sprite.play(animation_prefix + str(sprite_angle))

    #print(sprite_angle)
    var move_tween = self.create_tween().bind_node(self)
    move_tween.tween_property(self, "global_position", point, unit_data.speed_tile_per_sec)
    await move_tween.finished
    #pass
    #move_tween.kill()
  
  self.global_position = path[len(path) - 1]
  await self.get_tree().create_timer(0.05).timeout # let the _process run once.
  unit_sprite.stop()
  # restore the states
  self.is_moving = last_move_state
  self.visible = last_visible_state
