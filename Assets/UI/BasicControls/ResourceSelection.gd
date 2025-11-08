extends PanelContainer

class_name ResourceSelection

@onready var resource_selection_grid: GridContainer = %ResourceSelectionGrid

var inventory_slot_scene: PackedScene = preload("res://Assets/UI/BasicControls/InventorySlot.tscn")

signal resource_selected(resource: StringName)

func _ready() -> void:
  self.add_slots()

func add_slots():
  for resource in ResourceConfig.Resources.values():
    var slot: InventorySlot = self.inventory_slot_scene.instantiate()
    slot.resource_type = resource
    slot.resource_amount = GameStats.game_stats_resource.resources[resource]
    slot.pressed.connect(select_resource_button_pressed.bind(slot))
    self.resource_selection_grid.add_child(slot)

func select_resource_button_pressed(slot: InventorySlot):
  resource_selected.emit(slot.resource_type)
