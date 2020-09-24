extends Node

enum WindowMode {
	WINDOWED,
	FULLSCREEN
}

enum ResourceType {
	# Taken from fife version, started at 1 originally.
	GOLD             =  0,
	LAMB_WOOL        =  1,
	TEXTILE          =  2,
	BOARDS           =  3,
	FOOD             =  4,
	TOOLS            =  5,
	BRICKS           =  6,
	TREES            =  7,
	GRASS            =  8,
	WOOL             =  9,
	FAITH            = 10,
	WILDANIMALFOOD   = 11,
	DEER_MEAT        = 12,
	HAPPINESS        = 13,
	POTATOES         = 14,
	EDUCATION        = 15,
	RAW_SUGAR        = 16,
	SUGAR            = 17,
	COMMUNITY        = 18,
	RAW_CLAY         = 19,
	CLAY             = 20,
	LIQUOR           = 21,
	CHARCOAL         = 22,
	RAW_IRON         = 23,
	IRON_ORE         = 24,
	IRON_INGOTS      = 25,
	GET_TOGETHER     = 26,
	FISH             = 27,
	SALT             = 28,
	TOBACCO_PLANTS   = 29,
	TOBACCO_LEAVES   = 30,
	TOBACCO_PRODUCTS = 31,
	CATTLE           = 32,
	PIGS             = 33,
	CATTLE_SLAUGHTER = 34,
	PIGS_SLAUGHTER   = 35,
	HERBS            = 36,
	MEDICAL_HERBS    = 37,
	ACORNS           = 38,
	CANNON           = 39,
	SWORD            = 40,
	GRAIN            = 41,
	CORN             = 42,
	FLOUR            = 43,
	SPICE_PLANTS     = 44,
	SPICES           = 45,
	CONDIMENTS       = 46,
#	MARBLE_DEPOSIT   = GOLD, # 47
#	MARBLE_TOPS      = GOLD, # 48
#	COAL_DEPOSIT     = GOLD, # 49
	STONE_DEPOSIT    = 50,
	STONE_TOPS       = 51,
	COCOA_BEANS      = 52,
	COCOA            = 53,
	CONFECTIONERY    = 54,
	CANDLES          = 55,
	VINES            = 56,
	GRAPES           = 57,
	ALVEARIES        = 58,
	HONEYCOMBS       = 59,
#	GOLD_DEPOSIT     = GOLD, # 60
#	GOLD_ORE         = GOLD, # 61
#	GOLD_INGOTS      = GOLD, # 62
#	GEM_DEPOSIT      = GOLD, # 63
#	ROUGH_GEMS       = GOLD, # 64
#	GEMS             = GOLD, # 65
#	SILVER_DEPOSIT   = GOLD, # 66
#	SILVER_ORE       = GOLD, # 67
#	SILVER_INGOTS    = GOLD, # 68
#	COFFEE_PLANTS    = GOLD, # 69
#	COFFEE_BEANS     = GOLD, # 70
#	COFFEE           = GOLD, # 71
#	TEA_PLANTS       = GOLD, # 72
#	TEA_LEAVES       = GOLD, # 73
#	TEA              = GOLD, # 74
#	FLOWER_MEADOWS   = GOLD, # 75
#	BLOSSOMS         = GOLD, # 76
#	BRINE            = GOLD, # 77
#	BRINE_DEPOSIT    = GOLD, # 78
#	WHALES           = GOLD, # 79
#	AMBERGRIS        = GOLD, # 80
#	LAMP_OIL         = GOLD, # 81
#	COTTON_PLANTS    = GOLD, # 82
#	COTTON           = GOLD, # 83
#	INDIGO_PLANTS    = GOLD, # 84
#	INDIGO           = GOLD, # 85
#	GARMENTS         = GOLD, # 86
#	PERFUME          = GOLD, # 87
	HOP_PLANTS       = 88,
	HOPS             = 89,
	BEER             = 90,
	# 91-98 reserved for services
#	REPRESENTATION   = GOLD, # 91
#	SOCIETY          = GOLD, # 92
#	FAITH_2          = GOLD, # 93
#	EDUCATION_2      = GOLD, # 94
	HYGIENE          = 95,
#	RECREATION       = GOLD, # 96
	BLACKDEATH       = 97,
	FIRE             = 98,
	# 91-98 reserved for services
}

enum Faction {
	NONE,
	RED,
	BLUE,
	DARK_GREEN,
	ORANGE,
	PURPLE,
	CYAN,
	YELLOW,
	PINK,
	TEAL,
	LIME_GREEN,
	BORDEAUX,
	WHITE,
	GRAY,
	BLACK,
}

const RESOURCE_TYPES = [
	preload("res://Assets/UI/Icons/Resources/32/001.png"),
	preload("res://Assets/UI/Icons/Resources/32/002.png"),
	preload("res://Assets/UI/Icons/Resources/32/003.png"),
	preload("res://Assets/UI/Icons/Resources/32/004.png"),
	preload("res://Assets/UI/Icons/Resources/32/005.png"),
	preload("res://Assets/UI/Icons/Resources/32/006.png"),
	preload("res://Assets/UI/Icons/Resources/32/007.png"),
	preload("res://Assets/UI/Icons/Resources/32/008.png"),
	preload("res://Assets/UI/Icons/Resources/32/009.png"),
	preload("res://Assets/UI/Icons/Resources/32/010.png"),
	preload("res://Assets/UI/Icons/Resources/32/011.png"),
	preload("res://Assets/UI/Icons/Resources/32/012.png"),
	preload("res://Assets/UI/Icons/Resources/32/013.png"),
	preload("res://Assets/UI/Icons/Resources/32/014.png"),
	preload("res://Assets/UI/Icons/Resources/32/015.png"),
	preload("res://Assets/UI/Icons/Resources/32/016.png"),
	preload("res://Assets/UI/Icons/Resources/32/017.png"),
	preload("res://Assets/UI/Icons/Resources/32/018.png"),
	preload("res://Assets/UI/Icons/Resources/32/019.png"),
	preload("res://Assets/UI/Icons/Resources/32/020.png"),
	preload("res://Assets/UI/Icons/Resources/32/021.png"),
	preload("res://Assets/UI/Icons/Resources/32/022.png"),
	preload("res://Assets/UI/Icons/Resources/32/023.png"),
	preload("res://Assets/UI/Icons/Resources/32/024.png"),
	preload("res://Assets/UI/Icons/Resources/32/025.png"),
	preload("res://Assets/UI/Icons/Resources/32/026.png"),
	preload("res://Assets/UI/Icons/Resources/32/027.png"),
	preload("res://Assets/UI/Icons/Resources/32/028.png"),
	preload("res://Assets/UI/Icons/Resources/32/029.png"),
	preload("res://Assets/UI/Icons/Resources/32/030.png"),
	preload("res://Assets/UI/Icons/Resources/32/031.png"),
	preload("res://Assets/UI/Icons/Resources/32/032.png"),
	preload("res://Assets/UI/Icons/Resources/32/033.png"),
	preload("res://Assets/UI/Icons/Resources/32/034.png"),
	preload("res://Assets/UI/Icons/Resources/32/035.png"),
	preload("res://Assets/UI/Icons/Resources/32/036.png"),
	preload("res://Assets/UI/Icons/Resources/32/037.png"),
	preload("res://Assets/UI/Icons/Resources/32/038.png"),
	preload("res://Assets/UI/Icons/Resources/32/039.png"),
	preload("res://Assets/UI/Icons/Resources/32/040.png"),
	preload("res://Assets/UI/Icons/Resources/32/041.png"),
	preload("res://Assets/UI/Icons/Resources/32/042.png"),
	preload("res://Assets/UI/Icons/Resources/32/043.png"),
	preload("res://Assets/UI/Icons/Resources/32/044.png"),
	preload("res://Assets/UI/Icons/Resources/32/045.png"),
	preload("res://Assets/UI/Icons/Resources/32/046.png"),
	preload("res://Assets/UI/Icons/Resources/32/047.png"),
	#preload("res://Assets/UI/Icons/Resources/32/048.png"),
	#preload("res://Assets/UI/Icons/Resources/32/049.png"),
	#preload("res://Assets/UI/Icons/Resources/32/050.png"),
	preload("res://Assets/UI/Icons/Resources/32/051.png"),
	preload("res://Assets/UI/Icons/Resources/32/052.png"),
	preload("res://Assets/UI/Icons/Resources/32/053.png"),
	preload("res://Assets/UI/Icons/Resources/32/054.png"),
	preload("res://Assets/UI/Icons/Resources/32/055.png"),
	preload("res://Assets/UI/Icons/Resources/32/056.png"),
	preload("res://Assets/UI/Icons/Resources/32/057.png"),
	preload("res://Assets/UI/Icons/Resources/32/058.png"),
	preload("res://Assets/UI/Icons/Resources/32/059.png"),
	preload("res://Assets/UI/Icons/Resources/32/060.png"),
	#preload("res://Assets/UI/Icons/Resources/32/061.png"),
	#preload("res://Assets/UI/Icons/Resources/32/062.png"),
	#preload("res://Assets/UI/Icons/Resources/32/063.png"),
	#preload("res://Assets/UI/Icons/Resources/32/064.png"),
	#preload("res://Assets/UI/Icons/Resources/32/065.png"),
	#preload("res://Assets/UI/Icons/Resources/32/066.png"),
	#preload("res://Assets/UI/Icons/Resources/32/067.png"),
	#preload("res://Assets/UI/Icons/Resources/32/068.png"),
	#preload("res://Assets/UI/Icons/Resources/32/069.png"),
	preload("res://Assets/UI/Icons/Resources/32/070.png"),
	#preload("res://Assets/UI/Icons/Resources/32/061.png"),
	#preload("res://Assets/UI/Icons/Resources/32/062.png"),
	#preload("res://Assets/UI/Icons/Resources/32/063.png"),
	#preload("res://Assets/UI/Icons/Resources/32/064.png"),
	#preload("res://Assets/UI/Icons/Resources/32/065.png"),
	#preload("res://Assets/UI/Icons/Resources/32/066.png"),
	#preload("res://Assets/UI/Icons/Resources/32/067.png"),
	#preload("res://Assets/UI/Icons/Resources/32/068.png"),
	#preload("res://Assets/UI/Icons/Resources/32/069.png"),
	preload("res://Assets/UI/Icons/Resources/32/070.png"),
	#preload("res://Assets/UI/Icons/Resources/32/071.png"),
	#preload("res://Assets/UI/Icons/Resources/32/072.png"),
	#preload("res://Assets/UI/Icons/Resources/32/073.png"),
	#preload("res://Assets/UI/Icons/Resources/32/074.png"),
	#preload("res://Assets/UI/Icons/Resources/32/075.png"),
	#preload("res://Assets/UI/Icons/Resources/32/076.png"),
	#preload("res://Assets/UI/Icons/Resources/32/077.png"),
	#preload("res://Assets/UI/Icons/Resources/32/078.png"),
	#preload("res://Assets/UI/Icons/Resources/32/079.png"),
	#preload("res://Assets/UI/Icons/Resources/32/080.png"),
	#preload("res://Assets/UI/Icons/Resources/32/081.png"),
	#preload("res://Assets/UI/Icons/Resources/32/082.png"),
	#preload("res://Assets/UI/Icons/Resources/32/083.png"),
	#preload("res://Assets/UI/Icons/Resources/32/084.png"),
	#preload("res://Assets/UI/Icons/Resources/32/085.png"),
	#preload("res://Assets/UI/Icons/Resources/32/086.png"),
	#preload("res://Assets/UI/Icons/Resources/32/087.png"),
	#preload("res://Assets/UI/Icons/Resources/32/088.png"),
	preload("res://Assets/UI/Icons/Resources/32/089.png"),
	preload("res://Assets/UI/Icons/Resources/32/090.png"),
	preload("res://Assets/UI/Icons/Resources/32/091.png"),
	#preload("res://Assets/UI/Icons/Resources/32/092.png"),
	#preload("res://Assets/UI/Icons/Resources/32/093.png"),
	#preload("res://Assets/UI/Icons/Resources/32/094.png"),
	#preload("res://Assets/UI/Icons/Resources/32/095.png"),
	preload("res://Assets/UI/Icons/Resources/32/096.png"),
	#preload("res://Assets/UI/Icons/Resources/32/097.png"),
	preload("res://Assets/UI/Icons/Resources/32/098.png"),
	preload("res://Assets/UI/Icons/Resources/32/099.png"),
]

const FACTIONS = [
	"None",
	"Red",
	"Blue",
	"Dark Green",
	"Orange",
	"Purple",
	"Cyan",
	"Yellow",
	"Pink",
	"Teal",
	"Lime Green",
	"Bordeaux",
	"White",
	"Gray",
	"Black",
]

const FACTION_FLAGS = [
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_no_player.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_red.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_blue.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_dark_green.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_orange.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_purple.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_cyan.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_yellow.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_pink.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_teal.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_lime_green.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_bordeaux.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_white.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_gray.png"),
	preload("res://Assets/UI/Images/TabWidget/Emblems/emblem_black.png"),
]

const COLOR = [
	Color(0,       0,    0, 0), # Transparent black.
	Color(1,    0.04, 0.04, 1), # Red.
	Color(0,    0.28, 0.71, 1), # Sea Blue.
	Color(0,    0.63, 0.09, 1), # Dark Green.
	Color(0.88,  0.4,    0, 1), # Orange.
	Color(0.50,    0, 0.50, 1), # Purple.
	Color(0,       1,    1, 1), # Cyan.
	Color(1,    0.84,    0, 1), # Yellow.
	Color(1,       0,    1, 1), # Magenta.
	Color(0,    0.57, 0.55, 1), # Teal.
	Color(0,       1,    0, 1), # Lime Green.
	Color(0.59, 0.02, 0.16, 1), # Carmine Red.
	Color(1,       1,    1, 1), # White.
	Color(0.50, 0.50, 0.50, 1), # Gray.
	Color(0,       0,    0, 1), # Black.
];

const FACTION_COLOR_NONE =\
	preload("res://Assets/Player/FactionColor/FactionColorNone.tres")
const FACTION_COLOR_RED =\
	preload("res://Assets/Player/FactionColor/FactionColorRed.tres")
const FACTION_COLOR_BLUE =\
	preload("res://Assets/Player/FactionColor/FactionColorBlue.tres")
const FACTION_COLOR_DARK_GREEN =\
	preload("res://Assets/Player/FactionColor/FactionColorDarkGreen.tres")
const FACTION_COLOR_ORANGE =\
	preload("res://Assets/Player/FactionColor/FactionColorOrange.tres")
const FACTION_COLOR_PURPLE =\
	preload("res://Assets/Player/FactionColor/FactionColorPurple.tres")
const FACTION_COLOR_CYAN =\
	preload("res://Assets/Player/FactionColor/FactionColorCyan.tres")
const FACTION_COLOR_YELLOW =\
	preload("res://Assets/Player/FactionColor/FactionColorYellow.tres")
const FACTION_COLOR_PINK =\
	preload("res://Assets/Player/FactionColor/FactionColorPink.tres")
const FACTION_COLOR_TEAL =\
	preload("res://Assets/Player/FactionColor/FactionColorTeal.tres")
const FACTION_COLOR_LIME_GREEN =\
	preload("res://Assets/Player/FactionColor/FactionColorLimeGreen.tres")
const FACTION_COLOR_BORDEAUX =\
	preload("res://Assets/Player/FactionColor/FactionColorBordeaux.tres")
const FACTION_COLOR_WHITE =\
	preload("res://Assets/Player/FactionColor/FactionColorWhite.tres")
const FACTION_COLOR_GRAY =\
	preload("res://Assets/Player/FactionColor/FactionColorGray.tres")
const FACTION_COLOR_BLACK =\
	preload("res://Assets/Player/FactionColor/FactionColorBlack.tres")

const COLOR_MATERIAL = [
	FACTION_COLOR_NONE,
	FACTION_COLOR_RED,
	FACTION_COLOR_BLUE,
	FACTION_COLOR_DARK_GREEN,
	FACTION_COLOR_ORANGE,
	FACTION_COLOR_PURPLE,
	FACTION_COLOR_CYAN,
	FACTION_COLOR_YELLOW,
	FACTION_COLOR_PINK,
	FACTION_COLOR_TEAL,
	FACTION_COLOR_LIME_GREEN,
	FACTION_COLOR_BORDEAUX,
	FACTION_COLOR_WHITE,
	FACTION_COLOR_GRAY,
	FACTION_COLOR_BLACK,
]

const MESSAGE_SCENE = preload("res://Assets/UI/Scenes/Message.tscn")

#const WINDOW_MODES = [
#	WindowMode.WINDOWED,
#	WindowMode.FULLSCREEN
#]

const WINDOW_MODES = {
	WindowMode.WINDOWED: "Windowed",
	WindowMode.FULLSCREEN: "Fullscreen"
}

# Language choices
#const LANGUAGES = {
#	"Deutsch": "de",
#	"English": "en",
#	"Français": "fr",
#}

const LANGUAGES = [
	"de",
	"en",
	"fr",
]

const LANGUAGES_READABLE = {
	"de": "Deutsch",
	"en": "English",
	"fr": "Français",
}

#warning-ignore-all:unused_class_variable

# Game variables
var game_type := "FreePlay"
var faction := 1
var map: PackedScene
var ai_players := 0 # default should be 3 once AI is functional
var resource_density := 1.0
var has_traders := false
var has_pirates := true
var has_disasters := false
# -------
var Game: Spatial = null
var PlayerStart: MeshInstance = null

var _warning := false # DEBUG

func _ready() -> void:
	Config.load_config() # initialize with stored settings if available

	var window_mode = Config.window_mode
	var screen_resolution = Config.screen_resolution

	OS.window_fullscreen = window_mode
	set_screen_resolution(screen_resolution)

	pause_mode = Node.PAUSE_MODE_PROCESS

func set_screen_resolution(screen_resolution: String) -> void:
	var resolution = screen_resolution.split("x")
	resolution = Vector2(int(resolution[0]), int(resolution[1]))
	OS.set_window_size(resolution)
	OS.center_window()

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return

	# Only available during gameplay
	if get_tree().get_root().get_node_or_null("World/WorldEnvironment") != null:
		if event.is_action_pressed("time_speed_up"):
			Engine.time_scale += clamp(.1, 0, 2)
			prints("Time Scale:", Engine.time_scale)
		if event.is_action_pressed("time_slow_down"):
			Engine.time_scale -= clamp(.1, 0, 2)
			prints("Time Scale:", Engine.time_scale)
		if event.is_action_pressed("time_reset"):
			Engine.time_scale = 1
			prints("Time Scale:", Engine.time_scale)

		if event.is_action_pressed("pause_scene"):
			get_tree().paused = !get_tree().paused
			print(get_tree().paused)

		if event.is_action_pressed("restart_scene"):
			#warning-ignore:return_value_discarded
			get_tree().reload_current_scene()

	if event.is_action_pressed("toggle_fullscreen"):
		var window_mode = Config.window_mode

		window_mode = (window_mode + 1) % WINDOW_MODES.size()
		prints("window_mode:", window_mode)
		OS.window_fullscreen = !OS.window_fullscreen

		Config.window_mode = window_mode

	if event.is_action_pressed("quit_game"):
		get_tree().quit()
