extends BuildingMenuTabWidget

@onready var settlement_inventory: GridContainer = self.get_node("TabContainer/SettlementInventory/VBoxContainer/GridContainer")

func _process(_delta):
  if settlement_inventory.is_visible_in_tree(): # avoid extra functionality when not visible
    if len(self.selected_objects) == 1:
      update_inventory_slots()

func update_inventory_slots():
  var resource_slots: Array[Node] = self.settlement_inventory.get_children()
  var i: int = 0
  for resource in ResourceConfig.Resources.values():
    if resource == ResourceConfig.Resources.NONE:
      continue
    var resource_slot: InventorySlot = resource_slots[i]
    resource_slot.resource_type = resource
    resource_slot.resource_amount = GameStats.game_stats_resource.resources[resource]
    i += 1
