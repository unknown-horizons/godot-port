tool
extends TabWidget
class_name ShipAlienMenuTabWidget

#onready var faction_indicator = $WidgetDetail/Body/ShipMenu/MarginContainer/FactionIndicator
onready var faction_indicator = find_node("FactionIndicator")

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	faction_indicator.texture = Global.FACTION_FLAGS[Global.faction]
