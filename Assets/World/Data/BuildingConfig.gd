extends Object
## The building config has all the information about the buildings required

class_name BuildingConfig

## All the buildings represented in enum state
enum Buildings {
  NONE                 =   0,
  AMBIENT              = 100,
  BAKERY               = 101,
  BARRACKS             = 102,
  BARRIER              = 103,
  BLENDER              = 104,
  BOAT_BUILDER         = 105,
  BREWERY              = 106,
  BRICKYARD            = 107,
  BUTCHERY             = 108,
  CANNON_FOUNDRY       = 109,
  CHARCOAL_BURNER      = 110,
  CLAY_DEPOSIT         = 111,
  CLAY_PIT             = 112,
  DISTILLERY           = 113,
  DOCTOR               = 114,
  FARM                 = 115,
  FIRE_STATION         = 116,
  FISH_DEPOSIT         = 117,
  FISHER               = 118,
  HUNTER               = 119,
  LOOKOUT              = 120,
  LUMBERJACK           = 121,
  MAIN_SQUARE          = 122,
  MINE                 = 123,
  MOUNTAIN             = 124,
  PASTRY_SHOP          = 125,
  PAVILION             = 126,
  PUBLIC_BATH          = 127,
  SETTLER_RUIN         = 128,
  SALINE               = 129,
  SALT_PONDS           = 130,
  SIGNAL_FIRE          = 131,
  SMELTERY             = 132,
  STONE_DEPOSIT        = 133,
  STONEMASON           = 134,
  STONE_PIT            = 135,
  STORAGE              = 136,
  TAVERN               = 137,
  RESIDENTIAL          = 138,
  TOBACCONIST          = 139,
  TOOLMAKER            = 140,
  TRAIL                = 141,
  TREE                 = 142,
  VILLAGE_SCHOOL       = 143,
  WAREHOUSE            = 144,
  WEAPONSMITH          = 145,
  WEAVER               = 146,
  WINDMILL             = 147,
  WINERY               = 148,
  WOODEN_TOWER         = 149,
}

## Building enum value to the cost(resource to amount)
static var building_to_cost: Dictionary[Buildings, Dictionary] = {
  Buildings.NONE                : {},
  Buildings.AMBIENT             : {ResourceConfig.Resources.GOLD: 50},
  Buildings.BAKERY              : {ResourceConfig.Resources.BOARDS: 2, ResourceConfig.Resources.BRICKS: 3, ResourceConfig.Resources.GOLD: 500},
  Buildings.BARRACKS            : {ResourceConfig.Resources.BOARDS: 6, ResourceConfig.Resources.BRICKS: 8, ResourceConfig.Resources.GOLD: 1000, ResourceConfig.Resources.TOOLS: 4},
  Buildings.BARRIER             : {ResourceConfig.Resources.BOARDS: 1, ResourceConfig.Resources.GOLD: 10},
  Buildings.BLENDER             : {ResourceConfig.Resources.BOARDS: 3, ResourceConfig.Resources.BRICKS: 3, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 2},
  Buildings.BOAT_BUILDER        : {ResourceConfig.Resources.BOARDS: 4, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 3},
  Buildings.BREWERY             : {ResourceConfig.Resources.BOARDS: 2, ResourceConfig.Resources.BRICKS: 4, ResourceConfig.Resources.GOLD: 250, ResourceConfig.Resources.TOOLS: 2},
  Buildings.BRICKYARD           : {ResourceConfig.Resources.BOARDS: 6, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 1},
  Buildings.BUTCHERY            : {ResourceConfig.Resources.BRICKS: 4, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 3},
  Buildings.CANNON_FOUNDRY      : {ResourceConfig.Resources.BOARDS: 2, ResourceConfig.Resources.BRICKS: 2, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 2},
  Buildings.CHARCOAL_BURNER     : {ResourceConfig.Resources.BOARDS: 2, ResourceConfig.Resources.BRICKS: 3, ResourceConfig.Resources.GOLD: 250, ResourceConfig.Resources.TOOLS: 1},
  Buildings.CLAY_DEPOSIT        : {},
  Buildings.CLAY_PIT            : {ResourceConfig.Resources.BOARDS: 10, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 2},
  Buildings.DISTILLERY          : {ResourceConfig.Resources.BOARDS: 2, ResourceConfig.Resources.BRICKS: 4, ResourceConfig.Resources.GOLD: 250, ResourceConfig.Resources.TOOLS: 2},
  Buildings.DOCTOR              : {ResourceConfig.Resources.BOARDS: 3, ResourceConfig.Resources.BRICKS: 3, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 3},
  Buildings.FARM                : {ResourceConfig.Resources.BOARDS: 4, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 2},
  Buildings.FIRE_STATION        : {ResourceConfig.Resources.BOARDS: 3, ResourceConfig.Resources.BRICKS: 4, ResourceConfig.Resources.GOLD: 750, ResourceConfig.Resources.TOOLS: 2},
  Buildings.FISH_DEPOSIT        : {},
  Buildings.FISHER              : {ResourceConfig.Resources.BOARDS: 3, ResourceConfig.Resources.GOLD: 250, ResourceConfig.Resources.TOOLS: 1},
  Buildings.HUNTER              : {ResourceConfig.Resources.BOARDS: 2, ResourceConfig.Resources.GOLD: 250, ResourceConfig.Resources.TOOLS: 1},
  Buildings.LOOKOUT             : {ResourceConfig.Resources.BOARDS: 2, ResourceConfig.Resources.GOLD: 50},
  Buildings.LUMBERJACK          : {ResourceConfig.Resources.GOLD: 250, ResourceConfig.Resources.TOOLS: 2},
  Buildings.MAIN_SQUARE         : {ResourceConfig.Resources.BOARDS: 5, ResourceConfig.Resources.GOLD: 1000},
  Buildings.MINE                : {ResourceConfig.Resources.BOARDS: 10, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 2},
  Buildings.MOUNTAIN            : {},
  Buildings.PASTRY_SHOP         : {ResourceConfig.Resources.BOARDS: 2, ResourceConfig.Resources.BRICKS: 3, ResourceConfig.Resources.GOLD: 500},
  Buildings.PAVILION            : {ResourceConfig.Resources.BOARDS: 5, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 2},
  Buildings.PUBLIC_BATH         : {ResourceConfig.Resources.BOARDS: 4, ResourceConfig.Resources.GOLD: 350, ResourceConfig.Resources.TOOLS: 2},
  Buildings.SETTLER_RUIN        : {},
  Buildings.SALINE              : {ResourceConfig.Resources.BOARDS: 4, ResourceConfig.Resources.GOLD: 350, ResourceConfig.Resources.TOOLS: 2},
  Buildings.SALT_PONDS          : {ResourceConfig.Resources.BOARDS: 4, ResourceConfig.Resources.GOLD: 350, ResourceConfig.Resources.TOOLS: 2},
  Buildings.SIGNAL_FIRE         : {ResourceConfig.Resources.BOARDS: 5, ResourceConfig.Resources.GOLD: 50},
  Buildings.SMELTERY            : {ResourceConfig.Resources.BOARDS: 8, ResourceConfig.Resources.BRICKS: 6, ResourceConfig.Resources.GOLD: 1250, ResourceConfig.Resources.TOOLS: 4},
  Buildings.STONE_DEPOSIT       : {},
  Buildings.STONEMASON          : {ResourceConfig.Resources.BOARDS: 2, ResourceConfig.Resources.BRICKS: 3, ResourceConfig.Resources.GOLD: 500},
  Buildings.STONE_PIT           : {ResourceConfig.Resources.BOARDS: 10, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 2},
  Buildings.STORAGE             : {ResourceConfig.Resources.BOARDS: 4, ResourceConfig.Resources.GOLD: 350, ResourceConfig.Resources.TOOLS: 1},
  Buildings.TAVERN              : {ResourceConfig.Resources.BOARDS: 4, ResourceConfig.Resources.BRICKS: 4, ResourceConfig.Resources.GOLD: 250},
  Buildings.RESIDENTIAL         : {ResourceConfig.Resources.BOARDS: 2, ResourceConfig.Resources.GOLD: 100},
  Buildings.TOBACCONIST         : {ResourceConfig.Resources.BOARDS: 1, ResourceConfig.Resources.BRICKS: 4, ResourceConfig.Resources.GOLD: 250, ResourceConfig.Resources.TOOLS: 2},
  Buildings.TOOLMAKER           : {ResourceConfig.Resources.BOARDS: 2, ResourceConfig.Resources.BRICKS: 2, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 2},
  Buildings.TRAIL               : {ResourceConfig.Resources.GOLD: 5},
  Buildings.TREE                : {ResourceConfig.Resources.GOLD: 50},
  Buildings.VILLAGE_SCHOOL      : {ResourceConfig.Resources.BOARDS: 4, ResourceConfig.Resources.BRICKS: 4, ResourceConfig.Resources.GOLD: 500},
  Buildings.WAREHOUSE           : {ResourceConfig.Resources.BOARDS: 12, ResourceConfig.Resources.GOLD: 1000},
  Buildings.WEAPONSMITH         : {ResourceConfig.Resources.BOARDS: 2, ResourceConfig.Resources.BRICKS: 2, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 2},
  Buildings.WEAVER              : {ResourceConfig.Resources.BOARDS: 3, ResourceConfig.Resources.GOLD: 250, ResourceConfig.Resources.TOOLS: 2},
  Buildings.WINDMILL            : {ResourceConfig.Resources.BOARDS: 4, ResourceConfig.Resources.BRICKS: 5, ResourceConfig.Resources.GOLD: 400},
  Buildings.WINERY              : {ResourceConfig.Resources.BOARDS: 2, ResourceConfig.Resources.BRICKS: 3, ResourceConfig.Resources.GOLD: 500},
  Buildings.WOODEN_TOWER        : {ResourceConfig.Resources.BOARDS: 12, ResourceConfig.Resources.CANNON: 2, ResourceConfig.Resources.GOLD: 500, ResourceConfig.Resources.TOOLS: 3},
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