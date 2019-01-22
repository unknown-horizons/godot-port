extends Spatial

enum Rotations {
	ZERO,
	NINETY,
	ONE_EIGHTY,
	THREE_SIXTY
}

export(Texture) var texture setget set_texture
export(Rotations) var place_rotation = 0 setget set_place_rotation

onready var _billboard = $Billboard # as MeshInstance

func _ready():
	# Retry exported properties setters after all nodes are ready.
	set_texture(texture)
	set_place_rotation(place_rotation)

func _input(event):
	# Switch frame accordingly with the world rotation.
	if event.is_action_pressed("rotate_left"):
		_billboard.frame = wrapi(_billboard.frame - 1, Rotations.ZERO,
				Rotations.THREE_SIXTY + 1)
	elif event.is_action_pressed("rotate_right"):
		_billboard.frame = wrapi(_billboard.frame + 1, Rotations.ZERO,
				Rotations.THREE_SIXTY + 1)

func set_texture(new_texture):
	texture = new_texture
	
	if not is_inside_tree():
		return
	
	_billboard.texture = new_texture

func set_place_rotation(new_rotation):
	place_rotation = new_rotation
	
	if not is_inside_tree():
		return
	
	_billboard.frame = new_rotation
