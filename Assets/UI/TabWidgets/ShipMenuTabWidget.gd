@tool
extends TabWidget
class_name ShipMenuTabWidget

var selected_objects: Array = []

#onready var faction_indicator := $WidgetDetail/Body/ShipMenu/MarginContainer/FactionIndicator
@onready var faction_indicator := find_child("FactionIndicator")

func _ready() -> void:
  if Engine.is_editor_hint():
    return

  faction_indicator.texture = Global.FACTIONS[Global.faction].emblem

func _on_FoundSettlementButton_pressed():
  selected_objects[0].build_harbor()
