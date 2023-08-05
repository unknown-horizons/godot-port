@tool
@icon("res://Assets/UI/Icons/Widgets/CityInfo/settlement.png")
extends HBoxContainer
class_name CityInfo

## Info widget displaying generic information about the currently hovered city.

const _FACTION_SETTLEMENT = [
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

## Determines which faction color to be shown.
@export var faction: Global.Faction = 0 : set = set_faction
@export var _debug_cycle_factions := false : set = _debug_set_cycle_factions

@onready var _faction_settlement := $SettlementName/FactionSettlement as TextureRect
@onready var _animation_player := $AnimationPlayer

func _ready() -> void:
	if not Engine.is_editor_hint():
		visible = false

func set_faction(new_faction: int) -> void:
	if not is_inside_tree():
		await self.ready

	faction = new_faction
	_faction_settlement.texture = _FACTION_SETTLEMENT[faction]

	notify_property_list_changed()

func _debug_set_cycle_factions(new_debug_cycle_factions: bool) -> void:
	if not is_inside_tree():
		await self.ready

	_debug_cycle_factions = new_debug_cycle_factions
	if _debug_cycle_factions:
		$Timer.start()
	else:
		$Timer.stop()

## Fades the info board in.
func fade_in() -> void:
	if _animation_player.is_playing():
		_animation_player.stop(false)
	_animation_player.play("fade_in")

## Fades the info board out.
func fade_out() -> void:
	if _animation_player.is_playing():
		_animation_player.stop(false)
	_animation_player.play_backwards("fade_in")

func _on_Timer_timeout() -> void:
	self.faction = wrapi(faction + 1, 0, _FACTION_SETTLEMENT.size())

func _on_AnimationPlayer_animation_started(anim_name: String) -> void:
	match anim_name:
		"fade_in":
			visible = true

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"fade_out":
			visible = false
