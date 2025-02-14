@tool
extends Control

@onready var image_placeholder := $Background/HBoxContainer/ItemImageContainer/ImagePlaceholder

@export var texture: Texture2D:
  get:
    return texture
  set(value):
    texture = value
    if image_placeholder != null:
      image_placeholder.texture = value

@onready var amount_placeholder: Label = $Background/HBoxContainer/ItemAmountContainer/AmountPlaceholder

@export var amount: String:
  get:
    return amount
  set(value):
    amount = value
    if amount_placeholder != null:
      amount_placeholder.text = value

func _ready() -> void:
  image_placeholder.texture = self.texture
  amount_placeholder.text = self.amount
  pass
