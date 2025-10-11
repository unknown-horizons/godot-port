extends VBoxContainer

class_name InventoryTab

@onready var inventory_slots: GridContainer = $VBoxContainer/InventorySlots

func _process(_delta: float) -> void:
  if self.inventory_slots.is_visible_in_tree():
    update_inventory_slots()

func update_inventory_slots():
  var resource_slots: Array[Node] = self.inventory_slots.get_children()
  var i: int = 0
  for resource in ResourceConfig.Resources.values():
    if resource == ResourceConfig.Resources.NONE:
      continue
    var resource_slot: InventorySlot = resource_slots[i]
    resource_slot.resource_type = resource
    resource_slot.resource_amount = GameStats.game_stats_resource.resources[resource]
    i += 1
