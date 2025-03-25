extends Object
## The resource config is used to store all the item data, maping, and other item information

class_name ResourceConfig

const item_data_folder_path: String = "res://Assets/World/Data/ItemData/"

## The map of item names to items.[br]
static var item_map: Dictionary[Resources, ItemData] = {
  Resources.FLOUR: preload(item_data_folder_path + "Flour.tres"),
  Resources.FOOD: preload(item_data_folder_path + "Food.tres"),
  Resources.TIMBER: preload(item_data_folder_path + "Timber.tres"),
  Resources.WOOD: preload(item_data_folder_path + "Wood.tres"),
}

## The enum representing the resources
enum Resources {
  NONE,
  FLOUR,
  FOOD,
  TIMBER,
  WOOD,
}
