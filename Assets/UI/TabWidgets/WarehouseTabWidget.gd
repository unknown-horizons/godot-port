extends BuildingMenuTabWidget

@onready var settlement_inventory: GridContainer = self.get_node("TabContainer/SettlementInventory/VBoxContainer/GridContainer")

func _process(_delta):
  if settlement_inventory.is_visible_in_tree(): # avoid extra functionality when not visible
    if len(self.selected_objects) == 1:
      update_inventory_slots()

func update_inventory_slots():
  var resources: Dictionary = GameStats.game_stats_resource.resources
  for item_slot: InventorySlot in settlement_inventory.get_children():
    if item_slot.resource_type != null: # check if the item slot has a resource to display
      item_slot.limit = self.selected_objects[0].storage_capacity # set the limit
      if resources.has(item_slot.resource_type): # check if the inventory dict has the resource, Note: the dict starts of empty and gets the resource key when th resource becomes available.
        item_slot.resource_amount = resources.get(item_slot.resource_type) # set the amount of the resource
      else:
        item_slot.resource_amount = 0