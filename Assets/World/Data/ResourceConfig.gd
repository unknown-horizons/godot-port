@tool

extends Object
## The resource config is used to store all the item data, maping, and other item information

class_name ResourceConfig

const item_data_folder_path: String = "res://Assets/World/Data/ItemData/"

static var resource_to_icon: Dictionary[StringName, Texture2D] = {
  Resources.FLOUR:  preload("res://Assets/UI/Icons/Resources/32/044.png"),
  Resources.FOOD:   preload("res://Assets/UI/Icons/Resources/32/005.png"),
  Resources.BOARDS: preload("res://Assets/UI/Icons/Resources/32/004.png"),
  Resources.TREES:  preload("res://Assets/UI/Icons/Resources/32/008.png"),
  Resources.GOLD:   preload("res://Assets/UI/Icons/Resources/32/001.png"),
  Resources.TOOLS:  preload("res://Assets/UI/Icons/Resources/32/006.png"),
}

## The enum representing the resources
const Resources = {
  NONE   = &"NONE",
  GOLD   = &"GOLD",
  FLOUR  = &"FLOUR",
  FOOD   = &"FOOD",
  BOARDS = &"BOARDS",
  TREES  = &"TREES",
  TOOLS  = &"TOOLS",
}
