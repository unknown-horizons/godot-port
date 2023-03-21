@tool
extends Control
class_name PlayerHUD

signal button_tear_pressed
signal button_logbook_pressed
signal button_build_menu_pressed
signal button_diplomacy_pressed
signal button_game_menu_pressed

enum UIContext {
	NONE,
	TROOP,
	SHIP,
	SHIP_FOREIGN,
	BUILDING,
	BAKERY,
	BARRACKS,
	BATH,
	BLENDER,
	BOAT_BUILDER,
	BREWERY,
	BRICKYARD,
	BUTCHERY,
	CANNON_FOUNDRY,
	CHAPEL,
	CHARCOAL_BURNING,
	CLAY_PIT,
	DISTILLERY,
	DOCTOR,
	FARM,
	FIRE_STATION,
	FISHERMAN,
	HUNTER,
	LOOKOUT,
	LUMBERJACK,
	MAIN_SQUARE,
	PASTRY_SHOP,
	PIGSTY,
	RESIDENCE,
	SCHOOL,
	SMELTERY,
	STONEMASON,
	STONE_PIT,
	STORAGE,
	TAVERN,
	TOBACCONIST,
	TOOLMAKER,
	WAREHOUSE,
	WEAPONSMITH,
	WEAVER,
	WINDMILL,
	WINERY,
	WOODEN_TOWER,
	BUILD
}

#export var ui_contexts # (Array, NodePath)
@export var ui_context: UIContext = UIContext.NONE : set = set_ui_context
var context_data := {}

## All widget nodes cached here for quick use whenever context switches
var widgets: Array[TabWidget]

var queued_messages := []

var print_debug_messages = true
var _debug_messages = [
	[5, "Your game has been autosaved."],
	[3, "Some of your inhabitants have no access to the main square."],
	[2, "I'm just cleaning up here."],
	[1, "Some of your inhabitants have diarrhea."],
	[6, "A problem has occured. Do you want to send an error report?"],
	[4, "This is a very long text. That much, that it easily takes up to 3 lines. Believe it or not."]
]

@onready var balance_info_button := find_child("BalanceInfoButton")
@onready var city_info := find_child("CityInfo") as CityInfo
@onready var messages := find_child("Messages")

func _ready() -> void:
#	for context in ui_contexts:
#		widgets.append(get_node(context))

	for widget in $MarginContainer/HBoxContainer/Widgets.get_children():
		widgets.append(widget)

	prints("UIContext count:", UIContext.size())
	prints("widgets count:", widgets.size())

	if Engine.is_editor_hint():
		return

	self.ui_context = UIContext.NONE

func set_ui_context(new_ui_context: UIContext) -> void:
	if not is_inside_tree(): await self.ready; _on_ready()

	prints("Set UI context to", UIContext.keys()[new_ui_context])

	# Show fitting widget for selection, hide all other ones
	for index in widgets.size():
		if index == new_ui_context:
			widgets[index].visible = true
			if widgets[index].has_method("update_data"):
				widgets[index].update_data(context_data)
		else:
			widgets[index].visible = false

	ui_context = new_ui_context

func raise_notification(message_type: int, message_text: String) -> void:
	var _debug_message = _debug_messages[randi() % _debug_messages.size()]

	if messages.get_child_count() < 6:
		var message := Global.MESSAGE_SCENE.instantiate()

		if print_debug_messages:
			message_type = _debug_message[0]
			message_text = _debug_message[1]

		message.message_type = message_type
		message.message_text = message_text
		messages.add_child(message)
#	else:
#		queued_messages.append()

func _on_PlayerCamera_hovered() -> void:
	city_info.fade_in()

func _on_PlayerCamera_unhovered() -> void:
	city_info.fade_out()

func _on_PlayerCamera_selected(selected_entities: Array) -> void:
	prints("_on_PlayerCamera_selected", selected_entities)

	var new_context = UIContext.NONE
	for entity in selected_entities:
		if entity is String:
			new_context = UIContext.BUILD
			break
		if entity is Troop:
			new_context = UIContext.TROOP
			break
		if entity is Ship:
			if entity.faction == Global.Game.player.faction:
				new_context = UIContext.SHIP
			else:
				new_context = UIContext.SHIP_FOREIGN

			context_data = {
				"FactionIndicator": Global.FACTION_FLAGS[entity.faction],
				"Caption": entity.unit_name,
			}

			break
		if entity is Building:
			new_context = _get_context_type(entity)

			context_data = {
				"TownName": "Lübeck",
			}

	self.ui_context = new_context

func _get_context_type(entity: WorldThing) -> int:
	var context_name: String

	if entity is Building:
		var regex = RegEx.new()
		regex.compile("^[a-zA-Z]+")
		var cls_name = regex.search(entity.name).get_string()
		context_name = cls_name.capitalize().replace(" ", "_").to_upper() as String

	return UIContext.get(context_name, UIContext.BUILDING)

func _on_PlayerCamera_unselected() -> void:
	prints("_on_PlayerCamera_unselected")
	self.ui_context = UIContext.NONE

func _on_TabWidget_button_tear_pressed() -> void:
	emit_signal("button_tear_pressed")

func _on_TabWidget_button_logbook_pressed() -> void:
	emit_signal("button_logbook_pressed")

func _on_TabWidget_button_build_menu_pressed() -> void:
	emit_signal("button_build_menu_pressed")

func _on_TabWidget_button_diplomacy_pressed() -> void:
	emit_signal("button_diplomacy_pressed")

func _on_TabWidget_button_game_menu_pressed() -> void:
	emit_signal("button_game_menu_pressed")

func _on_ready() -> void:
	if widgets.is_empty():
#		for context in ui_contexts:
#			widgets.append(get_node(context))
		for widget in $MarginContainer/HBoxContainer/Widgets.get_children():
			widgets.append(widget)

		# Debug
		var debug_widgets := []
		for tab_widget in widgets:
			debug_widgets.append(tab_widget.name)
		prints("Widgets:", debug_widgets)
