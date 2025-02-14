extends Control
## Manages the resources overlay.
## If there are slots by defult, they to will be used.

class_name ResourceOverlay

@onready var resource_slots: HBoxContainer = self.get_node("HBoxContainer")
@onready var resource_selection: ResourceSelection = self.get_node("ResourceSelection")

const res_display_slot: PackedScene = preload("res://Assets/UI/BasicControls/ResourceDisplaySlot.tscn")

func _ready():
  # delete the default empty slots
  for slot: ResourceDisplaySlot in resource_slots.get_children():
    if slot.resource_type == null:
      slot.queue_free()
    else:
      slot.pressed.connect(pin_resource_to_slot.bind(slot))
  add_empty_resource_slot()

func add_empty_resource_slot() -> void:
  var empty_display_slot: ResourceDisplaySlot = res_display_slot.instantiate()
  resource_slots.add_child(empty_display_slot)
  empty_display_slot.pressed.connect(pin_resource_to_slot.bind(empty_display_slot))

## Returns true, if the resource is already shown, else: false
## Note: includes the empty slots
func is_already_shown(resource_type: ItemData) -> bool:
  for slot: ResourceDisplaySlot in resource_slots.get_children():
    if slot.resource_type == resource_type:
      return true
  return false

func pin_resource_to_slot(slot: ResourceDisplaySlot) -> void:
  var was_slot_empty: bool = slot.resource_type == null
  resource_selection.visible = true
  resource_selection.position.x = slot.position.x
  var resource_type = await resource_selection.resource_selected
  resource_selection.visible = false
  
  if resource_type == null and was_slot_empty == false: # if a pin is removed
    slot.queue_free()
    return
  if is_already_shown(resource_type): # if the resource is already shown then dont do anything, Note: includes the empty slots
    return
  if resource_type and was_slot_empty: # if a resource was selected and the empty slot was used
    add_empty_resource_slot()
  slot.resource_type = resource_type
