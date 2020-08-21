extends Spatial

const RAY_LENGTH = 1000

onready var _rotation_y := $RotationY as Spatial
onready var _camera := $RotationY/Camera as Camera
onready var _camera_controls = $CameraControls
onready var _selection_box = $SelectionBox

var selected_units = []
var start_sel_pos = Vector2()

var player = null

# HACK: Prevent triggering unit selection due to preceeding menu click
var first_frame = true

#func _ready() -> void:
#	get_tree().call_group(
#		"billboard",
#		"update_offset",
#		_rotation_y.rotation_degrees.y)
#	get_tree().call_group(
#		"billboard",
#		"recalculate_directions",
#		_rotation_y.rotation_degrees.y)

func assign_to_player() -> Control:
	return Global.Game.player if Global.Game != null and Global.Game.player else null

func _process(_delta: float) -> void:
	if first_frame:
		first_frame = false
		return

	# Unit selection if player is existing (no gameover, etc.)
	if not player:
		player = assign_to_player()
		return

	if player.camera == null:
		player.camera = self # bind player to this camera

	var m_pos = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("main_command"):
		move_selected_units(m_pos)
	if Input.is_action_just_pressed("alt_command"):
		_selection_box.start_sel_pos = m_pos
		start_sel_pos = m_pos
	if Input.is_action_pressed("alt_command"):
		_selection_box.m_pos = m_pos
		_selection_box.is_visible = true
	else:
		_selection_box.is_visible = false
	if Input.is_action_just_released("alt_command"):
		select_units(m_pos)

# Unit selection.
func select_units(m_pos: Vector2) -> void:
	var new_selected_units = []
	if m_pos.distance_squared_to(start_sel_pos) < 16: # Click.
		var u = get_object_under_mouse(m_pos)
		if u != null:
			new_selected_units.append(u)
		else:
			deselect_all()
	else: # moved more than a few pixels, use box select
		new_selected_units = get_units_in_box(start_sel_pos, m_pos)

	if new_selected_units.size() != 0:
		for unit in selected_units:
			unit.deselect()
		for unit in new_selected_units:
			unit.select()
		selected_units = new_selected_units
	else:
		deselect_all()

func deselect_all() -> void:
	for unit in selected_units:
		unit.deselect()
	selected_units = []

func move_selected_units(m_pos: Vector2) -> void:
	var result = raycast_from_mouse(m_pos, 1)
	if result:
		#print_debug("Command: Move selected units {0}".format([result]))
		for unit in selected_units:
			unit.move_to(result.position)

func get_object_under_mouse(m_pos: Vector2):
	var result = raycast_from_mouse(m_pos, 1)
	#print_debug("get_object_under_mouse({0}) result: {1}".format([m_pos, result]))

	prints("Collider:", result.collider.name, "Position:", result.position)

	if result and "faction" in result.collider.get_parent()\
	and result.collider.get_parent().faction == player.faction:
		return result.collider.get_parent()
	else:
		pass # TODO: Handle other interactions

func get_units_in_box(top_left: Vector2, bottom_right: Vector2) -> Array:
	if top_left.x > bottom_right.x:
		var tmp = top_left.x
		top_left.x = bottom_right.x
		bottom_right.x = tmp
	if top_left.y > bottom_right.y:
		var tmp = top_left.y
		top_left.y = bottom_right.y
		bottom_right.y = tmp
	var box = Rect2(top_left, bottom_right - top_left)
	var box_selected_units = []
	for unit in get_tree().get_nodes_in_group("units"):
		if unit.faction == player.faction and box.has_point(_camera.unproject_position(unit.global_transform.origin)):
			print_debug("Unit [{0}]".format([unit]))
			box_selected_units.append(unit)
	return box_selected_units

func raycast_from_mouse(m_pos: Vector2, collision_mask: int) -> Dictionary:
	var ray_start = _camera.project_ray_origin(m_pos)
	var ray_end = ray_start + _camera.project_ray_normal(m_pos) * RAY_LENGTH
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask)
