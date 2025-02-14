@tool

extends TextureButton

class_name InventorySlot

@export var resource_type: ItemData:
  get:
    return resource_type
  set(value):
    resource_type = value
    if resource_image == null:
      return
    # set the tooltips to the correct values
    if resource_type:
      resource_image.texture = resource_type.icon
    else:
      resource_image.texture = null

@export var resource_amount: int = 0:
  get:
    return resource_amount
  set(value):
    resource_amount = min(limit, value)
    if amount_label == null:
      return
    update_resource_amount_tooltips()

@export var limit: int = 30:
  get:
    return limit
  set(value):
    limit = value
    if self.is_node_ready() == false:
      return
    update_resource_amount_tooltips()

@onready var resource_image: TextureRect = self.get_node("HBoxContainer/ResourceImage")
@onready var amount_label: Label = self.get_node("HBoxContainer/VBoxContainer/AmountLabel")
@onready var amount_bar: TextureRect = self.get_node("HBoxContainer/VBoxContainer/AmountBar")
@onready var spacer: Control = self.get_node("HBoxContainer/VBoxContainer/Spacer")

signal slot_pressed

func _ready():
  if resource_type:
    resource_image.texture = resource_type.icon
  else:
    resource_image.texture = null
  update_resource_amount_tooltips()

func update_resource_amount_tooltips():
  amount_label.text = str(resource_amount)
  var resource_percentage = float(resource_amount) / float(limit)
  amount_bar.size_flags_stretch_ratio = resource_percentage
  spacer.size_flags_stretch_ratio = 1 - resource_percentage

## emits a signal with the slot when pressed
func _pressed():
  slot_pressed.emit(self)
