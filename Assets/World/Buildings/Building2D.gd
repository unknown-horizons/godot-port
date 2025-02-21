extends WorldThing2D
## Inherited by all 2D buildings,
## it has all the parameters and functions that all buildings need

class_name Building2D

## Data resource for the building
@export var building_data: BuildingData
## The sprite node of the building, if null will use the first found sprite
@export var building_sprite: Node2D:
  get:
    return building_sprite
  set(value):
    assert(value is Sprite2D or value is AnimatedSprite2D or value == null, "Sprite must be an AnimatedSprite2D or Sprite2D")
    building_sprite = value

## The shader to be used to highlight the sprite.
var highlight_shader: ShaderMaterial:
  get:
    return highlight_shader
  set(value):
    highlight_shader = value
    if building_sprite == null:
      return
    if highlight_shader == null:
      return
    building_sprite.material = highlight_shader.duplicate(true)
    highlight()

var is_highlight: bool = false:
  get:
    return is_highlight
  set(value):
    is_highlight = value
    highlight()

func _ready():
  if building_sprite == null:
    for child in self.get_children():
      if child is AnimatedSprite2D or child is Sprite2D:
        building_sprite = child
        break
  assert(building_sprite != null, "There was no sprite found to highlight in %s." % self.name)
  if highlight_shader != null:
    building_sprite.material = highlight_shader.duplicate(true)
  highlight()

## Used to highlight itself corresponding to the is_highlight variable
func highlight():
  if building_sprite and building_sprite.material:
    building_sprite.material.set_shader_parameter("should_show", is_highlight)