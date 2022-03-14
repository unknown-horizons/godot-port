extends Spatial
class_name PlayerCamera

signal hovered
signal unhovered
signal selected(selected_entities)
signal unselected

const RAY_LENGTH = 1000

export(NodePath) var default_interaction_context

var player: Player
var active_context: InteractionContext
var selected_entities: Array

var hovered_object: WorldThing setget set_hovered_object

# HACK: Prevent triggering unit selection due to preceeding menu click
#var _first_frame = true

onready var hud := $PlayerHUD

onready var _rotation_y := $RotationY as Spatial
onready var _camera := $RotationY/Camera as Camera
onready var _camera_controls = $CameraControls
onready var _selection_box = $SelectionBox

func set_hovered_object(new_hovered_object: WorldThing) -> void:
	if new_hovered_object != hovered_object:
		prints("set_hovered_object:", new_hovered_object)
		hovered_object = new_hovered_object
		emit_signal("hovered")

func _on_WorldThing_mouse_entered(object: WorldThing) -> void:
	hovered_object = object
	emit_signal("hovered")

func _on_WorldThing_mouse_exited(object: WorldThing) -> void:
	hovered_object = null
	emit_signal("unhovered")

func _ready() -> void:
	abort_context()

func _process(_delta: float) -> void:
#	if _first_frame:
#		_first_frame = false
#		return

	# Unit selection only if player is existing (no gameover, etc.)
	if not player:
		player = assign_to_player()
		return

	if player.camera == null:
		player.camera = self # bind player to this camera

		connect("hovered", hud, "_on_PlayerCamera_hovered")
		connect("unhovered", hud, "_on_PlayerCamera_unhovered")
		connect("selected", hud, "_on_PlayerCamera_selected")
		connect("unselected", hud, "_on_PlayerCamera_unselected")

func _unhandled_input(event: InputEvent) -> void:
	var target := raycast_from_mouse()
	var target_object: Spatial
	var target_pos: Vector2
	if target:
		target_object = (target["collider"] as CollisionObject).get_parent()
		target_pos = (Utils.map_3_to_2(target["position"]) as Vector2)

	#if target_object is WorldThing:
	#	print(target_object)

	#if hovered_object != null:
	#	target_object = hovered_object

	active_context.interact(event, target_object, target_pos)

func assign_to_player() -> Player:
	return Global.Game.player if Global.Game != null and Global.Game.player else null

func set_selection(new_selection: Array) -> void:
	if not new_selection:
		return

	unset_selection()

	#prints("new_selection:", new_selection)

	# First units, then buildings

	var selection_type := -1

	selection_type = SelectionContext.SelectionType.BUILDING # DEBUG
	for i in new_selection.size():
		var entity = new_selection[i]
		if entity is Unit:
			selection_type = SelectionContext.SelectionType.UNIT

			# Clean the array from buildings if any added before
			for j in selected_entities.size():
				var selected_entity = selected_entities[j]
				if selected_entity is Building:
					selected_entities.remove(j)

		# If any unit was found, ignore any building targets
		if selection_type == SelectionContext.SelectionType.UNIT:
			if entity is Building:
				continue

		entity.select()
		selected_entities.append(entity)

		if new_selection.size() == 1 and entity is Building:
			selection_type = SelectionContext.SelectionType.BUILDING
			break

	if selection_type == SelectionContext.SelectionType.UNIT:
		switch_context(find_node("MovementContext"))
	#elif selection_type == SelectionContext.SelectionType.BUILDING:
	#	switch_context(find_node("BuildingContext"))

	emit_signal("selected", selected_entities)

func unset_selection() -> void:
	if not selected_entities:
		return

	for entity in selected_entities:
		entity.deselect()
	selected_entities = []

	abort_context()

	emit_signal("unselected")

func raycast_from_mouse(collision_mask: int = -1) -> Dictionary:
	var m_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_start := _camera.project_ray_origin(m_pos)
	var ray_end := ray_start + _camera.project_ray_normal(m_pos) * RAY_LENGTH
	var space_state := get_world().direct_space_state
	var dict := space_state.intersect_ray(ray_start, ray_end, [], collision_mask, true, true)
	return dict

# Interaction system
func switch_context(new_context: InteractionContext) -> void:
	print("Switching to new context: %s" % new_context.name)
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

func _on_PlayerHUD_button_tear_pressed() -> void:
	switch_context(find_node("TearContext"))

func _on_PlayerHUD_button_logbook_pressed() -> void:
	var Logbook = preload("res://Assets/UI/Scenes/Logbook.tscn")
	get_tree().root.add_child(Logbook.instance())

func _on_PlayerHUD_button_build_menu_pressed() -> void:
	prints("TODO: Open Build Menu - select tile context for now")
	switch_context(find_node("TileContext"))

func _on_PlayerHUD_button_diplomacy_pressed() -> void:
	prints("TODO: Open Diplomacy Menu")

func _on_PlayerHUD_button_game_menu_pressed() -> void:
	prints("TODO: Open Game Menu")
