extends Node3D
class_name PlayerCamera

signal hovered
signal unhovered
signal selected(selected_entities)
signal unselected

const RAY_LENGTH = 1000

@export var default_interaction_context: NodePath

var player: Player
var active_context: InteractionContext
var selected_entities: Array

var hovered_object: WorldThing : set = set_hovered_object

@onready var hud := $PlayerHUD

@onready var _camera := $RotationY/Camera3D as Camera3D

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
	# Unit selection only if player is existing. (no gameover, etc.)
	if not player:
		player = assign_to_player()
		return

	if player.camera == null:
		player.camera = self # Bind player to this camera.

		connect("hovered", Callable(hud, "_on_PlayerCamera_hovered"))
		connect("unhovered", Callable(hud, "_on_PlayerCamera_unhovered"))
		connect("selected", Callable(hud, "_on_PlayerCamera_selected"))
		connect("unselected", Callable(hud, "_on_PlayerCamera_unselected"))

func _unhandled_input(event: InputEvent) -> void:
	var target := raycast_from_mouse()
	var target_object: Node3D
	var target_pos: Vector2
	if target:
		target_object = (target["collider"] as CollisionObject3D).get_parent()
		target_pos = (Utils.map_3_to_2(target["position"]) as Vector2)

	#if target_object is WorldThing:
	#	print(target_object)

	#if hovered_object != null:
	#	target_object = hovered_object

	active_context.interact(event, target_object, target_pos)

func assign_to_player() -> Player:
	return Global.Game.player if Global.Game != null and Global.Game.player else null

func set_selection(new_selection: Array) -> void:
	if new_selection.is_empty():
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

			# Clean the array from buildings if any added before.
			for j in selected_entities.size():
				var selected_entity = selected_entities[j]
				if selected_entity is Building:
					selected_entities.remove_at(j)

		# If any unit was found, ignore any building targets.
		if selection_type == SelectionContext.SelectionType.UNIT:
			if entity is Building:
				continue

		entity.select()
		selected_entities.append(entity)

		if new_selection.size() == 1 and entity is Building:
			selection_type = SelectionContext.SelectionType.BUILDING
			break

	if selection_type == SelectionContext.SelectionType.UNIT:
		switch_context(find_child("MovementContext") as InteractionContext)
	#elif selection_type == SelectionContext.SelectionType.BUILDING:
	#	switch_context(find_child("BuildingContext"))

	emit_signal("selected", selected_entities)

func unset_selection() -> void:
	if selected_entities.is_empty():
		# Close build menu when click on any free place.
		emit_signal("unselected")
		return

	for entity in selected_entities:
		entity.deselect()
	selected_entities = []

	abort_context()

	emit_signal("unselected")

func raycast_from_mouse(collision_mask: int = -1) -> Dictionary:
	#var m_pos: Vector2 = get_viewport().get_mouse_position()
	#var ray_start := _camera.project_ray_origin(m_pos)
	#var ray_end := ray_start + _camera.project_ray_normal(m_pos) * RAY_LENGTH
	#var space_state := get_world_3d().direct_space_state
	#var dict := space_state.intersect_ray(ray_start, ray_end, [], collision_mask, true, true)
	#return dict

	var mouse_pos := get_viewport().get_mouse_position()
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.new()
	query.collide_with_areas = true
	query.from = _camera.project_ray_origin(mouse_pos)
	query.to = query.from + _camera.project_ray_normal(mouse_pos) * RAY_LENGTH
	#query.exclude = [collision_mask] # gridmap.get_static_bodies_rids() TODO

	var result := space_state.intersect_ray(query)
	return result

# Interaction system
func switch_context(new_context: InteractionContext) -> void:
	print("Switching to new context: %s" % new_context.name)
	if active_context:
		active_context._on_exit()
	active_context = new_context
	Utils.ensure_connected(active_context.switch_context, switch_context)
	Utils.ensure_connected(active_context.context_aborted, abort_context)
	active_context._on_enter()

func abort_context() -> void:
	switch_context(get_node(default_interaction_context) as InteractionContext)

func _on_PlayerHUD_button_tear_pressed() -> void:
	switch_context(find_child("TearContext") as InteractionContext)

func _on_PlayerHUD_button_logbook_pressed() -> void:
	var Logbook = preload("res://Assets/UI/Pages/LogBookUI/LogbookUI.tscn")
	get_tree().root.add_child(Logbook.instantiate())

func _on_PlayerHUD_button_build_menu_pressed() -> void:
	prints("TODO: Open Build Menu - select tile context for now")
	# switch_context(find_child("TileContext"))
	emit_signal("selected", ["BuildMenu"])
	# switch_context(find_child("TileContext"))

func _on_PlayerHUD_button_diplomacy_pressed() -> void:
	prints("TODO: Open Diplomacy Menu")

func _on_PlayerHUD_button_game_menu_pressed() -> void:
	prints("TODO: Open Game Menu")
