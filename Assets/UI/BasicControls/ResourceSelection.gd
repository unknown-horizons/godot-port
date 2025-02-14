extends PanelContainer

class_name ResourceSelection

signal resource_selected(resource: ItemData)

func select_resource_button_pressed(slot: InventorySlot):
  resource_selected.emit(slot.resource_type)
