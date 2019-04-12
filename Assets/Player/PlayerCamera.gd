extends Spatial

const ZOOM_IN_LIMIT = 5
const ZOOM_OUT_LIMIT = 35
const ZOOM_VALUE = 5

const MOVE_SPEED = 10
const MOVE_FASTER_MULT = 3
const MOVE_VERTICAL_MULT = 1.5

var _directions := [Vector3(), Vector3(), Vector3(), Vector3()]

onready var _rotation_y := $RotationY as Spatial
onready var _camera := $RotationY/Camera as Camera

func _ready() -> void:
	recalculate_directions()

func _process(delta: float) -> void:
	# Camera movement.
	var movement_scale: float = delta * MOVE_SPEED
	if Input.is_action_pressed("move_faster"):
		movement_scale *= MOVE_FASTER_MULT
	
	# Not elif because movement should cancel out if both are pressed.
	if Input.is_action_pressed("move_up"):
		translate(_directions[0] * movement_scale * MOVE_VERTICAL_MULT)
	if Input.is_action_pressed("move_down"):
		translate(_directions[1] * movement_scale * MOVE_VERTICAL_MULT)
	if Input.is_action_pressed("move_left"):
		translate(_directions[2] * movement_scale)
	if Input.is_action_pressed("move_right"):
		translate(_directions[3] * movement_scale)

func _input(event: InputEvent) -> void:
	# Camera rotation.
	if event.is_action_pressed("rotate_left"):
		_rotation_y.rotate_y(- PI/2)
		recalculate_directions()
	elif event.is_action_pressed("rotate_right"):
		_rotation_y.rotate_y(PI / 2)
		recalculate_directions()
	
	# Camera zooming.
	elif event.is_action_pressed("zoom_in"):
		if _camera.size > ZOOM_IN_LIMIT:
			_camera.size -= ZOOM_VALUE
	elif event.is_action_pressed("zoom_out"):
		if _camera.size < ZOOM_OUT_LIMIT:
			_camera.size += ZOOM_VALUE

func recalculate_directions() -> void:
	# We could always hard-code the directions, but this is better.
	var basis: Basis = _rotation_y.get_transform().basis
	_directions[0] = -basis.z
	_directions[1] = basis.z
	_directions[2] = -basis.x
	_directions[3] = basis.x
