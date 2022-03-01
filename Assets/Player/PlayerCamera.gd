extends Spatial
class_name PlayerCamera

const RAY_LENGTH = 1000

onready var _rotation_y := $RotationY as Spatial
onready var _camera := $RotationY/Camera as Camera
onready var _camera_controls = $CameraControls
onready var _selection_box = $SelectionBox

var selected_units = []
var start_sel_pos = Vector2()

var player: Player = null

# Variables for the interaction system
export(NodePath) var default_interaction_context
var active_context: InteractionContext

# HACK: Prevent triggering unit selection due to preceeding menu click
var first_frame = true

func _ready() -> void:
	abort_context()

func _process(_delta: float) -> void:
	if first_frame:
		first_frame = false
		return

	# Unit selection only if player is existing (no gameover, etc.)
	if not player:
		player = assign_to_player()
		return

	if player.camera == null:
		player.camera = self # bind player to this camera

func _unhandled_input(event: InputEvent) -> void:
	var target := raycast_from_mouse()
	var target_object: Node
	var target_pos: Vector2
	if target:
		target_object = (target["collider"] as Node).get_parent()
		target_pos = (Utils.map_3_to_2(target["position"]) as Vector2)

	active_context.interact(event, target_object, target_pos)

func assign_to_player() -> Player:
	return Global.Game.player if Global.Game != null and Global.Game.player else null

func set_selection(new_selection: Array) -> void:
	unset_selection()
	for unit in new_selection:
		unit.select()
		selected_units.append(unit)

	print(new_selection)

	switch_context(find_node("MovementContext"))

func unset_selection() -> void:
	for unit in selected_units:
		unit.deselect()
	selected_units = []

func raycast_from_mouse(collision_mask: int = -1) -> Dictionary:
	var m_pos: Vector2 = get_viewport().get_mouse_position()
	#prints("m_pos:", m_pos)
	var ray_start := _camera.project_ray_origin(m_pos)
	var ray_end := ray_start + _camera.project_ray_normal(m_pos) * RAY_LENGTH
	var space_state := get_world().direct_space_state
	var dict := space_state.intersect_ray(ray_start, ray_end, [], collision_mask)
	#prints("intersect_ray:", dict)
	return dict

# Interaction system
func switch_context(new_context: InteractionContext) -> void:
	print_debug("Switching to new context: %s" % new_context.name)
	if active_context:
		active_context._on_exit()
	active_context = new_context
	if not active_context.is_connected("switch_context", self, "switch_context"):
		# warning-ignore:return_value_discarded
		active_context.connect("switch_context", self, "switch_context")
	if not active_context.is_connected("abort_context", self, "abort_context"):
		# warning-ignore:return_value_discarded
		active_context.connect("abort_context", self, "abort_context")
	active_context._on_enter()

func abort_context() -> void:
	switch_context(get_node(default_interaction_context))
