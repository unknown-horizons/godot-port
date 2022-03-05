tool
extends Control
class_name TabWidget
# Base class for all TabWidget objects.

signal button_tear_pressed
signal button_logbook_pressed
signal button_build_menu_pressed
signal button_diplomacy_pressed
signal button_game_menu_pressed

onready var body := find_node("Body") as Control

func _ready() -> void:
	if owner is PlayerHUD:
		connect("button_tear_pressed", owner, "_on_TabWidget_button_tear_pressed")
		connect("button_logbook_pressed", owner, "_on_TabWidget_button_logbook_pressed")
		connect("button_build_menu_pressed", owner, "_on_TabWidget_button_build_menu_pressed")
		connect("button_diplomacy_pressed", owner, "_on_TabWidget_button_diplomacy_pressed")
		connect("button_game_menu_pressed", owner, "_on_TabWidget_button_game_menu_pressed")

		# Hide empty detail widget section on runtime
		if body.get_child(0).get_child_count() == 0:
			$WidgetDetail.visible = false

#	if body.get_child_count() > 0:
#		var child_container = body.get_child(0) as Control
	if body.get_child_count() > 0:
		for child_container in body.get_children():
			#prints("Attach signals to", child_container.name, "of", self.name)
			#child_container.connect("resized", self, "_on_TabContainer_resized")
			#child_container.connect("draw", self, "_on_TabContainer_draw")
			child_container.connect("sort_children", self, "_on_TabContainer_sort_children")

#func _process(_delta: float) -> void:
#	if Engine.is_editor_hint():
#	_adapt_rect_size()

#func _draw() -> void:
#	if not is_inside_tree(): yield(self, "ready"); _on_ready()
#
#	body.rect_size.y = body.rect_min_size.y

func update_data(context_data: Dictionary) -> void:
	for data in context_data:
		prints("data:", data) # TownName
		var node = find_node(data)

		if node is Label:
			node.text = context_data[data]

func _adapt_rect_size() -> void:
	if body != null:
#		var child_container = body.get_child(0) as Control
#		if child_container:
#			prints("Adapt rect_min_size to body content:", child_container.name)
#			body.rect_min_size.y = child_container.rect_size.y

		# Keep the size of one tile visible at all times
		body.rect_min_size.y = body.texture.get_size().y

		# This will squeeze in all children to their least required sizes
		body.rect_size.y = body.rect_min_size.y

		# Now extend the whole thing based on the biggest child
		if body.get_child_count() > 0:
			#print("Adapt rect_min_size to body content consisting of:")
			#prints("Adapt rect_min_size for", self.name)
			for child_container in body.get_children():
				#print("\t", child_container.name)
				if child_container.rect_size.y > body.rect_min_size.y:
					body.rect_min_size.y = child_container.rect_size.y
		else:
			prints("No body content; set initial rect_size")

		# Bug? rect_size should always be >= rect_min_size.
		# Enforce it then.
		body.rect_size.y = body.rect_min_size.y

		var bottom_new_position = body.rect_position.y + body.rect_size.y - 1
		body.get_parent().get_children()[-1].rect_position.y = bottom_new_position

#func _on_TabContainer_resized() -> void:
#	prints("resized on", self.name)
#	_adapt_rect_size()
#
#func _on_TabContainer_draw() -> void:
#	prints("Draw call on", self.name)
#	_adapt_rect_size()

func _on_TabContainer_sort_children() -> void:
	#prints("sort_children on", self.name)
	_adapt_rect_size()

#func _notification(what: int) -> void:
#	match what:
#		NOTIFICATION_PARENTED:
#			prints(self, "has been parented.")

func _on_TearButton_pressed() -> void:
	emit_signal("button_tear_pressed")

func _on_LogbookButton_pressed() -> void:
	emit_signal("button_logbook_pressed")

func _on_BuildMenuButton_pressed() -> void:
	emit_signal("button_build_menu_pressed")

func _on_DiplomacyButton_pressed() -> void:
	emit_signal("button_diplomacy_pressed")

func _on_GameMenuButton_pressed() -> void:
	emit_signal("button_game_menu_pressed")

func _on_ready() -> void:
	if body == null: body = find_node("Body") as Control
