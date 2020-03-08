tool
extends TabWidget
class_name ShipMenuTabWidget

onready var faction_indicator = $WidgetDetail/Body/ShipMenu/MarginContainer/FactionIndicator

func _ready() -> void:
	faction_indicator.texture = Global.FACTION_FLAGS[Global.faction]
