extends Node
##

class_name Selectable

## The sprite to be highlighted when selected.
## If null, will use the first found animated sprite sibling.
@export var sprite: Node2D:
  get:
    return sprite
  set(value):
    assert(value is Sprite2D or value is AnimatedSprite2D or value == null, "Sprite must be an AnimatedSprite2D or Sprite2D")
    sprite = value
## The shader to be used to highlight the sprite.
@export var shader: ShaderMaterial = preload("res://Assets/World/Behavior/Selectable/SelectableDefultShader.tres")

@onready var parent: WorldThing2D = self.get_parent()

## The shader`s defult width
var shader_width: float = shader.get_shader_parameter("width")
## Whether the object is currently selected
var is_selected: bool = false:
  get:
    return is_selected
  set(value):
    is_selected = value
    # change the shader transparency to the correct one.
    if sprite:
      if is_selected:
        sprite.material.set_shader_parameter("width", shader_width)
      else:
        sprite.material.set_shader_parameter("width", 0)
    # notify the parent
    parent.selected(is_selected)

func _ready():
  if sprite == null:
    for child in self.get_parent().get_children():
      if child is AnimatedSprite2D or child is Sprite2D:
        sprite = child
        break
  if sprite == null:
    push_warning("There was no sprite found to highlight in %s." % self.get_parent().name)
  else:
    sprite.material = shader.duplicate(true)
    sprite.material.set_shader_parameter("width", 0)

func _unhandled_input(event):
  if is_selected:
    parent.handle_context_input(event)

func is_in_rect(rect: Rect2) -> bool:
  var parent_building = parent as Building2D
  if parent_building != null and parent.is_highlight:# if the parent is a unit, then it will be invisible because it will not start working
    return false
  if sprite:
    var sprite_size: Vector2
    if sprite is AnimatedSprite2D:
      var sprite_frame: Texture2D = sprite.get_sprite_frames().get_frame_texture(sprite.animation, sprite.frame)
      sprite_size = sprite_frame.get_size() * sprite.scale
    else:
      if sprite.region_enabled:
        sprite_size = sprite.region_rect.size * sprite.scale
      else:
        sprite_size = sprite.texture.get_size() * sprite.scale
    var sprite_rect: Rect2 = Rect2(sprite.global_position - sprite_size/2, sprite_size).abs()
    var does_intersect: bool = rect.intersects(sprite_rect) and parent.visible
    return does_intersect
  else:
    return false
