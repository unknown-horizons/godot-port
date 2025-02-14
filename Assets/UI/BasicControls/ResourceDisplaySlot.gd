@tool

extends TextureButton

class_name ResourceDisplaySlot

@export var resource_type: ItemData:
  get:
    return resource_type
  set(value):
    resource_type = value
    if self.is_node_ready() == false:
      return
    # set the resource_image to the correct icon
    if resource_type:
      resource_image.texture = resource_type.icon
    else:
      resource_image.texture = null

@export var resource_amount: int = 0:
  get:
    return resource_amount
  set(value):
    resource_amount = value
    if self.is_node_ready() == false:
      return
    # set the amount label to the correct amount
    resource_label.text = str(resource_amount)


@onready var resource_image: TextureRect = self.get_node("MarginContainer/VBoxContainer/MarginContainer/ResourceImage")
@onready var resource_label: Label = self.get_node("MarginContainer/VBoxContainer/MarginContainer2/ResourceAmount")

func _ready():
  # set process to run only in game.
  if Engine.is_editor_hint():
    self.set_process(false)
  else:
    self.set_process(true)

  if resource_type:
    resource_image.texture = resource_type.icon
  else:
    resource_image.texture = null
  resource_label.text = str(resource_amount)

func _process(_delta):
  if self.is_visible_in_tree():
    if resource_type:
      var resource_amount = GameStats.game_stats_resource.resources.get(resource_type)
      if resource_amount: # there might be no resource key yet because the it is created when the resource first is stored
        self.resource_amount = resource_amount
      else:
        self.resource_amount = 0
