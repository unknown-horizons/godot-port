extends Node

const ZOOM_IN_LIMIT = 10
const ZOOM_OUT_LIMIT = 60
const ZOOM_VALUE = 5
const RAY_LENGTH = 1000

const MOVE_SPEED = 1
const MOVE_FASTER_MULT = 2

# TODO: Delete Godot 3 styled node exports, if everything fine
#@export_node_path var origin_path: NodePath
#@export_node_path var camera_path: NodePath
#@export_node_path var rotation_y_path: NodePath

#@onready var _origin := get_node(origin_path) as Node3D
#@onready var _camera := get_node(camera_path) as Camera3D
#@onready var _rotation_y := get_node(rotation_y_path) as Node3D
@export var _origin: Node3D
@export var _camera: Camera3D
@export var _rotation_y: Node3D
@onready var _viewport := get_viewport() as Viewport
@onready var _viewport_size := _viewport.size as Vector2
@onready var _viewport_aspect := _viewport_size.aspect() as float

var _basis: Basis
var _drag_pos: Vector2
var enabled: bool = true : set = set_enabled, get = get_enabled

func _ready() -> void:
	if not _viewport.size_changed.connect(Callable(self, "_on_viewport_size_changed")):
		push_error("Failed To connect viewport")
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
	var movement_scale: float = delta * MOVE_SPEED * _camera.size
	if Input.is_action_pressed("move_faster"):
		movement_scale *= MOVE_FASTER_MULT

	var x := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var movement_velocity := Vector2(x, y * _viewport_aspect)
	_origin.translate(_basis * Utils.map_2_to_3(movement_velocity) * movement_scale)

func _move_drag() -> void:
	if Input.is_action_pressed("move_drag"):
		var new_drag_pos := _viewport.get_mouse_position()
		if Input.is_action_just_pressed("move_drag"):
			_drag_pos = new_drag_pos
		else:
			# DEBUG
			#if new_drag_pos != _drag_pos:
			#	prints(_drag_pos, "=>", new_drag_pos)
			var drag_dir = (_drag_pos - new_drag_pos) * _camera.size / _viewport_size * 6
			var move_dir := _basis * Utils.map_2_to_3(drag_dir)
			_origin.translate(move_dir)
			_drag_pos = new_drag_pos

func _rotate(rotation: float) -> void:
	_rotation_y.rotate_y(rotation)
	_basis = _get_basis()

func _zoom(zoom_value: float) -> void:
	var m_pos := _viewport.get_mouse_position()
	var start_result := _raycast_from_mouse(m_pos, 1)
	_camera.size += zoom_value
	var end_result := _raycast_from_mouse(m_pos, 1)
	if not (start_result.is_empty() and end_result.is_empty()):
		var move_dir: Vector3i = start_result.position - end_result.position
		_origin.translate(move_dir)

func _raycast_from_mouse(m_pos: Vector2, collision_mask: int) -> Dictionary:
	var mouse_pos := get_viewport().get_mouse_position()
	var space_state := _origin.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.new()
	query.from = _camera.project_ray_origin(mouse_pos)
	query.to = query.from + _camera.project_ray_normal(mouse_pos) * RAY_LENGTH
	query.collision_mask = collision_mask

	var result := space_state.intersect_ray(query)
	return result

func _get_basis() -> Basis:
	return _rotation_y.get_transform().basis

func set_enabled(new_value: bool) -> void:
	enabled = new_value

	set_process(enabled)
	set_process_input(enabled)

func get_enabled() -> bool:
	return enabled

func _on_viewport_size_changed() -> void:
	_viewport_size = _viewport.size
	_viewport_aspect = _viewport_size.aspect()
