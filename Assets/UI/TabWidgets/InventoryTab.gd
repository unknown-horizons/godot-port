extends VBoxContainer

class_name InventoryTab

@onready var inventory_slots: GridContainer = $VBoxContainer/InventorySlots

var selected_node: WorldThing2D = null

func _process(_delta: float) -> void:
  if self.inventory_slots.is_visible_in_tree():
    update_inventory_slots()

func update_inventory_slots():
  self.clear_inventory_slots()
  var resource_slots: Array[Node] = self.inventory_slots.get_children()
  var i: int = 0
  var selected_building := self.selected_node as Building2D
  if selected_building == null:
    push_error("Selected node is not a building and InventoryTab.gd shown")
    return
  var storage_items: Array[StringName] = selected_building.get_storage_items()
  for resource in storage_items:
    if resource == ResourceConfig.Resources.NONE:
      continue
    var resource_amount := selected_building.get_resource_amount(resource)
    var max_capacity := selected_building.get_max_resource_amount(resource)
    var resource_slot: InventorySlot = resource_slots[i]
    resource_slot.resource_type = resource
    resource_slot.resource_amount = resource_amount
    resource_slot.limit = max_capacity
    i += 1

func clear_inventory_slots():
  var resource_slots: Array[Node] = self.inventory_slots.get_children()
  for resource_slot: InventorySlot in resource_slots:
    resource_slot.resource_type = ResourceConfig.Resources.NONE
    resource_slot.resource_amount = 0
