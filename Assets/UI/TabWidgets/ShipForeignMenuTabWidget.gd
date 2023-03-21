@tool
extends TabWidget
class_name ShipForeignMenuTabWidget

#onready var faction_indicator := $WidgetDetail/Body/ShipMenu/MarginContainer/FactionIndicator
@onready var faction_indicator := find_child("FactionIndicator")

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	faction_indicator.texture = Global.FACTION_FLAGS[Global.faction]

func update_data(context_data: Dictionary) -> void:
	for data in context_data:
		prints("data:", data) # TownName
		var node := find_child(data)

		if node is Label:
			node.text = context_data[data]

		if data == "FactionIndicator":
			faction_indicator.texture = context_data[data]
