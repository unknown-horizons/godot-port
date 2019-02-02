extends Spatial

enum RotationSteps {
	NINETY = 1,
	FOURTY_FIVE = 2,
}

enum RotationDegrees {
	ZERO,
	FORTY_FIVE,
	NINETY,
	ONE_THIRTY_FIVE,
	ONE_EIGHTY,
	TWO_TWENTY_FIVE,
	TWO_SEVENTY,
	THREE_FIFTEEN
}

export(Texture) var texture setget set_texture
export(RotationSteps) var rotation_step = 1 setget set_rotation_step
export(RotationDegrees) var rotation_degree = 0 setget set_rotation_degree

onready var _billboard = $Billboard # as MeshInstance

func _ready():
	# Retry exported properties setters after all nodes are ready.
	set_texture(texture)
	set_rotation_step(rotation_step)
	set_rotation_degree(rotation_degree)

func _input(event):
	# Switch frame accordingly with the world rotation.
	if event.is_action_pressed("rotate_left"):
		_billboard.frame = wrapi(_billboard.frame - rotation_step, 0,
				_billboard.hframes * _billboard.vframes)
	elif event.is_action_pressed("rotate_right"):
		_billboard.frame = wrapi(_billboard.frame + rotation_step, 0,
				_billboard.hframes * _billboard.vframes)

func set_texture(new_texture):
	texture = new_texture
	
	if not is_inside_tree():
		return
	
	_billboard.texture = new_texture

func set_rotation_step(new_step):
	rotation_step = new_step
	
	if not is_inside_tree():
		return
	
	match new_step:
		RotationSteps.FOURTY_FIVE:
			_billboard.hframes = 4
		RotationSteps.NINETY:
			_billboard.hframes = 2

func set_rotation_degree(new_rotation):
	rotation_degree = new_rotation
	
	if not is_inside_tree():
		return
	
	match rotation_step:
		RotationSteps.FOURTY_FIVE:
			_billboard.frame = new_rotation
		RotationSteps.NINETY:
			if new_rotation % 2 != 0:
				printerr(str(self) +
						" - Invalid rotation for current rotation step.")
				
				return
			
			_billboard.frame = new_rotation / 2
