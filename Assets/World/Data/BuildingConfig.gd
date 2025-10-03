extends Object
## The building config has all the information about the buildings required

class_name BuildingConfig

## All the buildings represented in enum state
enum Buildings {
  NONE       = 0,
  BAKERY     = 1,
  LUMBERJACK = 2,
  FARM       = 3,
  WAREHOUSE  = 4
}

# ## Building enum value to the scene of it
# static var building_to_scene: Dictionary[Buildings, PackedScene] = {
#   Buildings.BAKERY:         preload("res://Assets/World/Buildings/Bakery/Bakery.tscn"),
#   Buildings.LUMBERJACK: preload("res://Assets/World/Buildings/Lumberjack/LumberjackTent2D.tscn"),
#   Buildings.FARM:           preload("res://Assets/World/Buildings/Agricultural/Farm/Farm.tscn"),
#   Buildings.WAREHOUSE:      preload("res://Assets/World/Buildings/Warehouse/Warehouse.tscn")
# }

# static var building_to_texture = {
#   Buildings.BAKERY:         preload("res://Assets/World/Buildings/Bakery/Sprites/Bakery_idle.png"),
#   Buildings.LUMBERJACK: preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackTent_idle.png"),
#   Buildings.FARM:           preload("res://Assets/World/Buildings/Agricultural/Farm/Sprites/Farm_idle.png"),
#   Buildings.WAREHOUSE:      preload("res://Assets/World/Buildings/Warehouse/Sprites/Warehouse_idle.png")
# }

## Building enum value to the cost(resource to amount)
static var building_to_cost: Dictionary[Buildings, Dictionary] = {
  Buildings.NONE:       {},
  Buildings.BAKERY:     {ResourceConfig.Resources.TIMBER: 1},
  Buildings.LUMBERJACK: {},
  Buildings.FARM:       {ResourceConfig.Resources.TIMBER: 1},
  Buildings.WAREHOUSE:  {ResourceConfig.Resources.TIMBER: 1}
}

## Building enum value to the atlas(x) and the id(y)
static var building_to_tile: Dictionary[Buildings, Vector2i] = {
  Buildings.NONE:       Vector2i(-1, -1),
  Buildings.BAKERY:     Vector2i(0, 3),
  Buildings.LUMBERJACK: Vector2i(0, 1),
  Buildings.FARM:       Vector2i(0, 2),
  Buildings.WAREHOUSE:  Vector2i(0, 0)
}

## building enum to info tab widget scene
static var building_to_info_tab_widget: Dictionary[Buildings, Resource] = {
  Buildings.NONE:       null,
  Buildings.BAKERY:     preload("res://Assets/UI/TabWidgets/BakeryTabWidget.tscn"),
  Buildings.LUMBERJACK: preload("res://Assets/UI/TabWidgets/LumberjackTabWidget.tscn"),
  Buildings.FARM:       preload("res://Assets/UI/TabWidgets/FarmTabWidget.tscn"),
  Buildings.WAREHOUSE:  preload("res://Assets/UI/TabWidgets/WarehouseTabWidget.tscn")
}