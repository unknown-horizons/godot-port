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
@export var shader: ShaderMaterial = preload("res://Assets/World/Components/Selectable/SelectableDefultShader.tres")

@export var type: String

@export var tabs: Array[String] = []

@export var enemy_tabs: Array[String] = [] # TODO: not used yet

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
		if self.sprite:
			if self.sprite.material != shader:
				self.sprite.material = shader.duplicate(true)
			if is_selected:
				self.sprite.material.set_shader_parameter("width", shader_width)
			else:
				self.sprite.material.set_shader_parameter("width", 0)
		# notify the parent
		parent.selected(is_selected)

func _ready():
	if self.sprite == null and self.has_node("../BuildingActionSet/AnimatedSprite2D"): # check the sibling ../BuildingActionSet component:
		self.sprite = self.get_node("../BuildingActionSet/AnimatedSprite2D") as AnimatedSprite2D
	if self.sprite == null: # fallback to look up any sibling Sprite2D
		for child in self.get_parent().get_children():
			if child is AnimatedSprite2D or child is Sprite2D:
				self.sprite = child
				break
	if self.sprite == null:
		push_warning("There was no sprite found to highlight in %s." % self.get_parent().name)

func _unhandled_input(event):
	if is_selected:
		parent.handle_context_input(event)

func is_in_rect(rect: Rect2) -> bool:
	if self.sprite:
		var sprite_size: Vector2
		if self.sprite is AnimatedSprite2D:
			var sprite_frame: Texture2D = self.sprite.get_sprite_frames().get_frame_texture(self.sprite.animation, self.sprite.frame)
			sprite_size = sprite_frame.get_size() * self.sprite.scale
		else:
			if self.sprite.region_enabled:
				sprite_size = self.sprite.region_rect.size * self.sprite.scale
			else:
				sprite_size = self.sprite.texture.get_size() * self.sprite.scale
		var sprite_rect: Rect2 = Rect2(sprite.global_position + sprite.offset, sprite_size).abs() # TODO: test this logic with negative scale and centered sprite
		# var sprite_rect: Rect2 = Rect2(sprite.global_position - sprite_size/2, sprite_size).abs()
		var does_intersect: bool = rect.intersects(sprite_rect) and parent.visible
		# print("%s does_intersect: %s" % [self.get_path(), does_intersect])
		return does_intersect
	else:
		return false
