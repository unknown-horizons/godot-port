extends Control
class_name Player

var faction = Global.Factions.NONE

var settlements = []
var ships = []

var camera

#warning-ignore-all:unused_class_variable

func _ready() -> void:
	print_debug(
		"I'm {0} in faction {1} ({2}).".format(
		[Global.player_name, faction, Global.FACTIONS[faction]]))

func _on_Game_notification(message_type, message_text) -> void:
	if camera != null:
		var hud = camera.get_node("PlayerHud")
		hud.raise_notification(message_type, message_text)
