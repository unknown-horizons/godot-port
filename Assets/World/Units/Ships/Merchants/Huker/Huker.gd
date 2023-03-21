@tool
extends Ship
class_name Huker

@onready var faction_color: Sprite3D = find_child("FactionColor") as Sprite3D

func update_faction_color() -> void:
	if faction_color != null:
		faction_color.modulate = Global.FACTION_COLORS[faction]

		# Match rotation of the ship's color outline with the main texture rotation
		faction_color.frame = _billboard.frame
