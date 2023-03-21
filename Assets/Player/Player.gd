extends Control
class_name Player

var faction = Global.Faction.NONE

var settlements = []
var ships = []

var camera: PlayerCamera

func _ready() -> void:
	print_debug(
		"I'm {0} in faction {1} ({2}).".format(
				[Config.player_name, faction, Global.FACTIONS[faction]])
		)

func _on_Game_notification(message_type: int, message_text: String) -> void:
	if camera != null:
		var hud := camera.get_node("PlayerHUD") as PlayerHUD
		hud.raise_notification(message_type, message_text)
