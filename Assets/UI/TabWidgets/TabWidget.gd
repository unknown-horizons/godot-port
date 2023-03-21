@tool
extends Control
class_name TabWidget

## Base class for all TabWidget objects.

signal button_tear_pressed
signal button_logbook_pressed
signal button_build_menu_pressed
signal button_diplomacy_pressed
signal button_game_menu_pressed

@onready var body := find_child("Body") as Control

func _ready() -> void:
	if owner is PlayerHUD:
		connect("button_tear_pressed", Callable(owner, "_on_TabWidget_button_tear_pressed"))
		connect("button_logbook_pressed", Callable(owner, "_on_TabWidget_button_logbook_pressed"))
		connect("button_build_menu_pressed", Callable(owner, "_on_TabWidget_button_build_menu_pressed"))
		connect("button_diplomacy_pressed", Callable(owner, "_on_TabWidget_button_diplomacy_pressed"))
		connect("button_game_menu_pressed", Callable(owner, "_on_TabWidget_button_game_menu_pressed"))

		# Hide empty detail widget section on runtime
		if body.get_child(0).get_child_count() == 0:
			$WidgetDetail.visible = false

#	if body.get_child_count() > 0:
#		var child_container = body.get_child(0) as Control
	if body.get_child_count() > 0:
		for child_container in body.get_children():
			#prints("Attach signals to", child_container.name, "of", self.name)
			#child_container.resized.connect(Callable(self, "_on_TabContainer_resized"))
			#child_container.draw.connect(Callable(self, "_on_TabContainer_draw"))
			child_container.sort_children.connect(Callable(self, "_on_TabContainer_sort_children"))

#func _process(_delta: float) -> void:
#	if Engine.is_editor_hint():
#	_adapt_rect_size()

#func _draw() -> void:
#	if not is_inside_tree(): await self.ready; _on_ready()
#
#	body.size.y = body.custom_minimum_size.y

func update_data(context_data: Dictionary) -> void:
	for data in context_data:
		prints("data:", data) # TownName
		var node := find_child(data)

		if node is Label:
			node.text = context_data[data]

func _adapt_rect_size() -> void:
	if body != null:
		var child_container = body.get_child(1) as TabContainer
		if child_container:
			#prints("Adapt custom_minimum_size to body content:", child_container.name)
			body.custom_minimum_size.y = child_container.size.y

#func _on_TabContainer_resized() -> void:
#	prints("resized checked", self.name)
#	_adapt_rect_size()
#
#func _on_TabContainer_draw() -> void:
#	prints("Draw call checked", self.name)
#	_adapt_rect_size()

func _on_TabContainer_sort_children() -> void:
	#prints("sort_children checked", self.name)
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

func _on_TabWidget_visibility_changed() -> void:
	if self.name != "TabWidget":
		if visible:
			prints(self.name, "opened.")
