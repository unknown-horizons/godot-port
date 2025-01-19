@tool
extends Control
class_name TabWidget

## Base class for all TabWidget objects.

signal button_tear_pressed
signal button_logbook_pressed
signal button_build_menu_pressed
signal button_diplomacy_pressed
signal button_game_menu_pressed
signal building_started

#@onready var body := find_child("Body") as Control

#func _ready() -> void:
  #var playerHUD = owner as PlayerHUD;
  #if playerHUD != null:
    #button_tear_pressed.connect(owner._on_TabWidget_button_tear_pressed)
    #button_logbook_pressed.connect(owner._on_TabWidget_button_logbook_pressed)
    #button_build_menu_pressed.connect(playerHUD._on_TabWidget_button_build_menu_pressed)
    #button_diplomacy_pressed.connect(owner._on_TabWidget_button_diplomacy_pressed)
    #button_game_menu_pressed.connect(owner._on_TabWidget_button_game_menu_pressed)
#
    ## Hide empty detail widget section on runtime
    #if body.get_child(0).get_child_count() == 0:
      #$WidgetDetail.visible = false
#
##	if body.get_child_count() > 0:
##		var child_container = body.get_child(0) as Control
  #if body.get_child_count() > 0:
    #for child_container in body.get_children():
      ##prints("Attach signals to", child_container.name, "of", self.name)
      ##child_container.resized.connect(_on_TabContainer_resized)
      ##child_container.draw.connect(_on_TabContainer_draw)
      #child_container.sort_children.connect(_on_TabContainer_sort_children)

#func _process(_delta: float) -> void:
#	if Engine.is_editor_hint():
#	_adapt_rect_size()

#func _draw() -> void:
#	if not is_inside_tree():
#		await self.ready
#
#	body.size.y = body.custom_minimum_size.y

func update_data(context_data: Dictionary) -> void:
  for data in context_data:
    prints("data:", data) # TownName
    var node := find_child(data)

    if node is Label:
      node.text = context_data[data]

#func _adapt_rect_size() -> void:
  #if body != null:
    #var child_container = body.get_child(1) as TabContainer
    #if child_container:
      ##prints("Adapt custom_minimum_size to body content:", child_container.name)
      #body.custom_minimum_size.y = child_container.size.y

#func _on_TabContainer_resized() -> void:
#	prints("resized checked", self.name)
#	_adapt_rect_size()
#
#func _on_TabContainer_draw() -> void:
#	prints("Draw call checked", self.name)
#	_adapt_rect_size()

#func _on_TabContainer_sort_children() -> void:
  ##prints("sort_children checked", self.name)
  #_adapt_rect_size()

#func _notification(what: int) -> void:
#	match what:
#		NOTIFICATION_PARENTED:
#			prints(self, "has been parented.")

func _on_TearButton_pressed() -> void:
  button_tear_pressed.emit()

func _on_LogbookButton_pressed() -> void:
  button_logbook_pressed.emit()

func _on_BuildMenuButton_pressed() -> void:
  var event = InputEventAction.new();
  event.action = "toggle_building_menu";
  event.pressed = true;
  Input.parse_input_event(event);
  # event.is_action_pressed("toggle_building_menu")
  # button_build_menu_pressed.emit()

func _on_DiplomacyButton_pressed() -> void:
  button_diplomacy_pressed.emit()

func _on_GameMenuButton_pressed() -> void:
  button_game_menu_pressed.emit()

func _on_TabWidget_visibility_changed() -> void:
  if self.name != "TabWidget":
    if visible:
      prints(self.name, "opened.")

func _input(event: InputEvent) -> void:
  if event.is_action_pressed("toggle_building_menu"):
    # print("Hi!")
    # print(event)
    # self._on_BuildMenuButton_pressed()
    button_build_menu_pressed.emit()

  # elif event.is_action_pressed("toggle_diplomacy_menu"):
  #   button_diplomacy_pressed.emit()

  # elif event.is_action_pressed("toggle_game_menu"):
  #   button_game_menu_pressed.emit()

  # elif event.is_action_pressed("toggle_logbook"):
  #   button_logbook_pressed.emit()

  # elif event.is_action_pressed("toggle_tear"):
  #   button_tear_pressed.emit()

# func BuildBuilding(building_name: String) -> void:
#   var event = InputEventAction.new();
#   event.action = "toggle_build_building";
#   event.pressed = true;
#   event.set_meta("building_name", building_name);
#   Input.parse_input_event(event);
  # building_started.emit(building_name)
