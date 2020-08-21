extends Node

const ZOOM_IN_LIMIT = 5
const ZOOM_OUT_LIMIT = 35
const ZOOM_VALUE = 5
const RAY_LENGTH = 1000

const MOVE_SPEED = 10
const MOVE_FASTER_MULT = 3

export(NodePath) var origin_path: NodePath
export(NodePath) var camera_path: NodePath
export(NodePath) var rotation_y_path: NodePath

onready var _origin := get_node(origin_path) as Spatial
onready var _camera := get_node(camera_path) as Camera
onready var _rotation_y := get_node(rotation_y_path) as Spatial
onready var _viewport := get_viewport() as Viewport
onready var _viewport_size := _viewport.size as Vector2
onready var _viewport_aspect := _viewport_size.aspect() as float

var _basis: Basis
var _move_drag_start: Vector2
var enabled: bool = true setget set_enabled, get_enabled

func _ready() -> void:
	if _viewport.connect("size_changed", self, "_on_viewport_size_changed") != OK:
		push_error("Failed To Connect Viewport")
	_basis = _get_basis()

func _process(delta: float) -> void:
	_move(delta)
	_move_drag()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("rotate_left"):
		_rotate(-PI/2)

	elif event.is_action_pressed("rotate_right"):
		_rotate(PI/2)

	elif event.is_action_pressed("zoom_in"):
		if _camera.size > ZOOM_IN_LIMIT:
			_zoom(-ZOOM_VALUE)

	elif event.is_action_pressed("zoom_out"):
		if _camera.size < ZOOM_OUT_LIMIT:
			_zoom(ZOOM_VALUE)

func _move(delta: float) -> void:
	var movement_scale: float = delta * MOVE_SPEED
	if Input.is_action_pressed("move_faster"):
		movement_scale *= MOVE_FASTER_MULT

	var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var movement_velocity = Vector3(x, 0, y * _viewport_aspect)
	_origin.translate(_basis.xform(movement_velocity) * movement_scale)

func _move_drag() -> void:
	if Input.is_action_pressed("move_drag"):
		var m_pos = _viewport.get_mouse_position()
		if Input.is_action_just_pressed("move_drag"):
			_move_drag_start = m_pos
		else:
			var drag_dir = (_move_drag_start - m_pos) * _camera.size / _viewport_size
			var move_dir = _basis.xform(Vector3(drag_dir.x, 0, drag_dir.y))
			_origin.translate(move_dir)
			_move_drag_start = m_pos

func _rotate(rotation: float) -> void:
	_rotation_y.rotate_y(rotation)
	_basis = _get_basis()

func _zoom(zoom_value: float) -> void:
	var m_pos = _viewport.get_mouse_position()
	var start_result = _raycast_from_mouse(m_pos, 1)
	_camera.size += zoom_value
	var end_result = _raycast_from_mouse(m_pos, 1)
	if start_result and end_result:
		var move_dir = start_result.position - end_result.position
		_origin.translate(move_dir)

func _raycast_from_mouse(m_pos: Vector2, collision_mask: int) -> Dictionary:
	var ray_start = _camera.project_ray_origin(m_pos)
	var ray_end = ray_start + _camera.project_ray_normal(m_pos) * RAY_LENGTH
	var space_state = _origin.get_world().direct_space_state
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask)

func _get_basis() -> Basis:
	return _rotation_y.get_transform().basis

func set_enabled(new_value: bool) -> void:
	set_process(new_value)
	set_process_input(new_value)
	enabled = new_value

func get_enabled() -> bool:
	return enabled

func _on_viewport_size_changed() -> void:
	_viewport_size = _viewport.size
	_viewport_aspect = _viewport_size.aspect()
