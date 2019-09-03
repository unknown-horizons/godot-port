extends Control
class_name Player

var faction = Global.Factions.NONE

var settlements = []
var ships = []

func _ready() -> void:
	print_debug(
		"I'm in fraction {0} ({1}).".format(
		[faction, Global.FACTIONS[faction]]))
