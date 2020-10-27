tool
extends Spatial
class_name WorldThing

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

export var texture: Texture setget set_texture
export(RotationStep) var rotation_step := 1 setget set_rotation_step
export(RotationDegree) var rotation_degree := 0 setget set_rotation_degree

onready var _billboard := $Billboard as Sprite3D

func _ready() -> void:
	# Retry exported properties setters after all nodes are ready.
	set_texture(texture)
	set_rotation_step(rotation_step)
	set_rotation_degree(rotation_degree)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if _billboard == null:
			prints("Please reload the scene [{0}].".format([name]))
			set_process(false)
			return

		# Prevent things "falling" through the GridMap when drag'n'dropping
		# nodes from the hierarchy to the map;
		# keep everything on the same height at all time.
		if translation.y != 0:
			translation.y = 0

func _unhandled_input(event: InputEvent) -> void:
	_on_input(event)

func _on_input(event: InputEvent):
	# Switch frame accordingly with the world rotation.
	if event.is_action_pressed("rotate_left"):
		_billboard.frame = wrapi(_billboard.frame - rotation_step, 0,
				_billboard.hframes * _billboard.vframes)
	elif event.is_action_pressed("rotate_right"):
		_billboard.frame = wrapi(_billboard.frame + rotation_step, 0,
				_billboard.hframes * _billboard.vframes)

func next_frame(sprite: Sprite3D = _billboard) -> int:
	return wrapi(sprite.frame + 1, 0, sprite.vframes * sprite.hframes)

func prev_frame(sprite: Sprite3D = _billboard) -> int:
	return wrapi(sprite.frame - 1, 0, sprite.vframes * sprite.hframes)

func random_frame(sprite: Sprite3D = _billboard) -> int:
	return randi() % (sprite.vframes * sprite.hframes)

func set_texture(new_texture: Texture) -> void:
	texture = new_texture

	if not is_inside_tree() or _billboard == null:
		return

	_billboard.texture = texture

	if texture != null:
		var material = SpatialMaterial.new()
		material.flags_transparent = true
		material.flags_no_depth_test = true
		material.params_billboard_mode = SpatialMaterial.BILLBOARD_ENABLED
		material.albedo_texture = texture
		_billboard.material_override = material
	else:
		_billboard.material_override = null

func set_rotation_step(new_step: int) -> void:
	rotation_step = new_step

	if not is_inside_tree() or _billboard == null:
		return

#	match new_step:
#		RotationStep.FOURTY_FIVE:
#			_billboard.hframes = 4
#		RotationStep.NINETY:
#			_billboard.hframes = 2

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

			#warning-ignore:integer_division
			_billboard.frame = rotation_degree / 2
