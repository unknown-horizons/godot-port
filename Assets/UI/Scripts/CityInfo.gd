tool
extends HBoxContainer
# Info widget displaying generic information about the hovered city

const FACTION_SETTLEMENT = [
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement.png"), # neutral
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_red.png"),
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_blue.png"),
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_dark_green.png"),
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_orange.png"),
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_purple.png"),
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_cyan.png"),
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_yellow.png"),
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_pink.png"),
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_teal.png"),
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_lime_green.png"),
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_bordeaux.png"),
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_white.png"),
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_gray.png"),
	preload("res://Assets/UI/Icons/Widgets/CityInfo/settlement_black.png")
]

export(Global.Faction) var faction := 0 setget set_faction
export(bool) var debug_cycle_factions := false setget debug_set_cycle_factions

onready var faction_settlement = $SettlementName/FactionSettlement

func set_faction(new_faction: int) -> void:
	if not is_inside_tree(): yield(self, "ready")

	faction = new_faction
	faction_settlement.texture = FACTION_SETTLEMENT[faction]

	property_list_changed_notify()

func debug_set_cycle_factions(new_debug_cycle_factions: bool) -> void:
	if not is_inside_tree(): yield(self, "ready")

	debug_cycle_factions = new_debug_cycle_factions
	if debug_cycle_factions:
		$Timer.start()
	else:
		$Timer.stop()

func _on_Timer_timeout() -> void:
	self.faction = wrapi(faction + 1, 0, FACTION_SETTLEMENT.size())
