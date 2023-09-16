@tool
extends Node3D
class_name WorldThing

## The base class of any entity in the game.

const TRANSLATION_PER_ANGLE = [
	Vector3(-50, 49.51, 50),
	Vector3(50, 49.51, 50),
	Vector3(50, 49.51, -50),
	Vector3(-50, 49.51, -50),
]

enum RotationStep {
	NINETY = 1,
	FOURTY_FIVE = 2,
}

enum RotationDegree {
	ZERO,
	FORTY_FIVE,
	NINETY,
	ONE_THIRTY_FIVE,
	ONE_EIGHTY,
	TWO_TWENTY_FIVE,
	TWO_SEVENTY,
	THREE_FIFTEEN
}

@export var texture: Texture2D:
	set(new_texture):
		texture = new_texture

		if not is_inside_tree() or _billboard == null:
			return

		_billboard.texture = texture

		# Set up outline for object highlighting
		if texture != null:
			_outline.texture = _billboard.texture
			_outline.hframes = _billboard.hframes
			_outline.vframes = _billboard.vframes
			_outline.region_rect = _billboard.region_rect
			_outline.region_enabled = _billboard.region_enabled
			_outline.offset = _billboard.offset

			var material := StandardMaterial3D.new()
			material.flags_transparent = true
			material.flags_no_depth_test = true
			material.params_billboard_mode = StandardMaterial3D.BILLBOARD_ENABLED
			material.params_use_alpha_scissor = true
			material.params_alpha_scissor_threshold = 0.05
			material.albedo_texture = texture
			material.emission_enabled = true
			material.emission = Color.WHITE
			_outline.material_overlay = material
		else:
			_outline.material_overlay = null

		# Every Sprite3D should be a billboard
		_billboard.billboard = StandardMaterial3D.BILLBOARD_ENABLED
		_billboard.transparent = true
		_billboard.no_depth_test = true
		_billboard.material_override = null

@export var rotation_step: RotationStep = 1:
	set(new_rotation_step):
		rotation_step = new_rotation_step

		if not is_inside_tree() or _billboard == null:
			return

		#match new_rotation_step:
		#	RotationStep.FOURTY_FIVE:
		#		_billboard.hframes = 4
		#	RotationStep.NINETY:
		#		_billboard.hframes = 2

@export var rotation_degree: RotationDegree = 0 : set = set_rotation_degree

@onready var _billboard := $Billboard as Sprite3D
@onready var _outline := _billboard.get_node("Outline") as Sprite3D

var current_rotation := 0

func _ready() -> void:
	# Invoke at the very start to set up the billboard rotation correctly.
	set_rotation_degree(rotation_degree)

	if not Engine.is_editor_hint():
		_recalculate_translation()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if _billboard == null:
			prints("Please reload the scene [{0}].".format([name]))
			set_process(false)
			return

		# Prevent things "falling" through the GridMap when drag'n'dropping
		# nodes from the hierarchy to the map;
		# keep everything on the same height at all times.
		if position.y != 0:
			position.y = 0

func _unhandled_input(event: InputEvent) -> void:
	_recalculate_translation(event)
	_on_input(event)

func _on_input(event: InputEvent):
	# Switch frame accordingly with the world rotation.
	if event.is_action_pressed("rotate_left"):
		_billboard.frame = wrapi(_billboard.frame - rotation_step, 0,
				_billboard.hframes * _billboard.vframes)

	elif event.is_action_pressed("rotate_right"):
		_billboard.frame = wrapi(_billboard.frame + rotation_step, 0,
				_billboard.hframes * _billboard.vframes)

func _recalculate_translation(event: InputEvent = null) -> void:
	if not event:
		_billboard.position = TRANSLATION_PER_ANGLE[0]
		return

	if event.is_action_pressed("rotate_left"):
		current_rotation = wrapi(current_rotation - 1, 0, TRANSLATION_PER_ANGLE.size())
		_billboard.position = TRANSLATION_PER_ANGLE[current_rotation]
		#prints(self, "position:", _billboard.position)
	elif event.is_action_pressed("rotate_right"):
		current_rotation =  wrapi(current_rotation + 1, 0, TRANSLATION_PER_ANGLE.size())
		_billboard.position = TRANSLATION_PER_ANGLE[current_rotation]
		#prints(self, "position:", _billboard.position)

func next_frame(sprite: Sprite3D = _billboard) -> int:
	return wrapi(sprite.frame + 1, 0, sprite.vframes * sprite.hframes)

func prev_frame(sprite: Sprite3D = _billboard) -> int:
	return wrapi(sprite.frame - 1, 0, sprite.vframes * sprite.hframes)

func get_random_frame(sprite: Sprite3D = _billboard) -> int:
	return randi() % (sprite.vframes * sprite.hframes)

func set_hover(enabled: bool) -> void:
	_billboard.get_node("Outline").visible = enabled

func set_rotation_degree(new_rotation: int) -> void:
	rotation_degree = new_rotation

	if not is_inside_tree() or _billboard == null:
		return

	match rotation_step:
		RotationStep.FOURTY_FIVE: # Units.
			_billboard.frame = rotation_degree
		RotationStep.NINETY: # Buildings.
			if rotation_degree % 2 != 0:
				printerr(str(self.name) +
						" - Invalid rotation for current rotation step.")
				return

			@warning_ignore("integer_division")
			_billboard.frame = rotation_degree / 2

func _on_Billboard_frame_changed() -> void:
	if _billboard == null:
		return

	# Sync frames
	_outline.frame = _billboard.frame
