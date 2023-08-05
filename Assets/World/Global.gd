extends Node

enum WindowMode {
	WINDOWED,
	FULLSCREEN
}

enum ResourceType {
	# Taken from FIFE version
	NONE             =  0,
	GOLD             =  1,
	LAMB_WOOL        =  2,
	TEXTILE          =  3,
	BOARDS           =  4,
	FOOD             =  5,
	TOOLS            =  6,
	BRICKS           =  7,
	TREES            =  8,
	GRASS            =  9,
	WOOL             = 10,
	FAITH            = 11,
	WILDANIMALFOOD   = 12,
	DEER_MEAT        = 13,
	HAPPINESS        = 14,
	POTATOES         = 15,
	EDUCATION        = 16,
	RAW_SUGAR        = 17,
	SUGAR            = 18,
	COMMUNITY        = 19,
	RAW_CLAY         = 20,
	CLAY             = 21,
	LIQUOR           = 22,
	CHARCOAL         = 23,
	RAW_IRON         = 24,
	IRON_ORE         = 25,
	IRON_INGOTS      = 26,
	GET_TOGETHER     = 27,
	FISH             = 28,
	SALT             = 29,
	TOBACCO_PLANTS   = 30,
	TOBACCO_LEAVES   = 31,
	TOBACCO_PRODUCTS = 32,
	CATTLE           = 33,
	PIGS             = 34,
	CATTLE_SLAUGHTER = 35,
	PIGS_SLAUGHTER   = 36,
	HERBS            = 37,
	MEDICAL_HERBS    = 38,
	ACORNS           = 39,
	CANNON           = 40,
	SWORD            = 41,
	GRAIN            = 42,
	CORN             = 43,
	FLOUR            = 44,
	SPICE_PLANTS     = 45,
	SPICES           = 46,
	CONDIMENTS       = 47,
#	MARBLE_DEPOSIT   = GOLD, # 48
#	MARBLE_TOPS      = GOLD, # 49
#	COAL_DEPOSIT     = GOLD, # 50
	STONE_DEPOSIT    = 51,
	STONE_TOPS       = 52,
	COCOA_BEANS      = 53,
	COCOA            = 54,
	CONFECTIONERY    = 55,
	CANDLES          = 56,
	VINES            = 57,
	GRAPES           = 58,
	ALVEARIES        = 59,
	HONEYCOMBS       = 60,
#	GOLD_DEPOSIT     = GOLD, # 61
#	GOLD_ORE         = GOLD, # 62
#	GOLD_INGOTS      = GOLD, # 63
#	GEM_DEPOSIT      = GOLD, # 64
#	ROUGH_GEMS       = GOLD, # 65
#	GEMS             = GOLD, # 66
#	SILVER_DEPOSIT   = GOLD, # 67
#	SILVER_ORE       = GOLD, # 68
#	SILVER_INGOTS    = GOLD, # 69
#	COFFEE_PLANTS    = GOLD, # 70
#	COFFEE_BEANS     = GOLD, # 71
#	COFFEE           = GOLD, # 72
#	TEA_PLANTS       = GOLD, # 73
#	TEA_LEAVES       = GOLD, # 74
#	TEA              = GOLD, # 75
#	FLOWER_MEADOWS   = GOLD, # 76
#	BLOSSOMS         = GOLD, # 77
#	BRINE            = GOLD, # 78
#	BRINE_DEPOSIT    = GOLD, # 79
#	WHALES           = GOLD, # 80
#	AMBERGRIS        = GOLD, # 81
#	LAMP_OIL         = GOLD, # 82
#	COTTON_PLANTS    = GOLD, # 83
#	COTTON           = GOLD, # 84
#	INDIGO_PLANTS    = GOLD, # 85
#	INDIGO           = GOLD, # 86
#	GARMENTS         = GOLD, # 87
#	PERFUME          = GOLD, # 88
	HOP_PLANTS       = 89,
	HOPS             = 90,
	BEER             = 91,
	# 92-99 reserved for services
#	REPRESENTATION   = GOLD, # 92
#	SOCIETY          = GOLD, # 93
#	FAITH_2          = GOLD, # 94
#	EDUCATION_2      = GOLD, # 95
	HYGIENE          = 96,
#	RECREATION       = GOLD, # 97
	BLACKDEATH       = 98,
	FIRE             = 99,
	# 92-99 reserved for services
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
	MAGENTA,
	TEAL,
	LIME_GREEN,
	BORDEAUX,
	WHITE,
	GRAY,
	BLACK,
}

const RESOURCE_TYPES = [
	null,
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
	null,#preload("res://Assets/UI/Icons/Resources/32/048.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/049.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/050.png"),
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
	null,#preload("res://Assets/UI/Icons/Resources/32/061.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/062.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/063.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/064.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/065.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/066.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/067.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/068.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/069.png"),
	preload("res://Assets/UI/Icons/Resources/32/070.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/071.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/072.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/073.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/074.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/075.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/076.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/077.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/078.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/079.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/080.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/081.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/082.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/083.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/084.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/085.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/086.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/087.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/088.png"),
	preload("res://Assets/UI/Icons/Resources/32/089.png"),
	preload("res://Assets/UI/Icons/Resources/32/090.png"),
	preload("res://Assets/UI/Icons/Resources/32/091.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/092.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/093.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/094.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/095.png"),
	preload("res://Assets/UI/Icons/Resources/32/096.png"),
	null,#preload("res://Assets/UI/Icons/Resources/32/097.png"),
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

const FACTION_COLORS = [
	Color8(  0,   0,   0,   0), # None (transparent black).
	Color8(250,  10,  10, 255), # Red.
	Color8(  0,  71, 181, 255), # Sea Blue.
	Color8(  0, 158,  23, 255), # Dark Green.
	Color8(224, 102,   0, 255), # Orange.
	Color8(128,   0, 128, 255), # Purple.
	Color8(  0, 255, 255, 255), # Cyan.
	Color8(255, 214,   0, 255), # Yellow.
	Color8(255,   0, 255, 255), # Magenta.
	Color8(  0, 145, 140, 255), # Teal.
	Color8(  0, 255,   0, 255), # Lime Green.
	Color8(150,   5,  41, 255), # Bordeaux Red.
	Color8(255, 255, 255, 255), # White.
	Color8(128, 128, 128, 255), # Gray.
	Color8(  0,   0,   0, 255), # Black.
]

const MESSAGE_SCENE = preload("res://Assets/UI/Notification/Message.tscn")

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

# Game variables
var game_type := "FreePlay"
var faction := 1
var map: PackedScene
var ai_players := 0 # default should be 3 once AI is functional
var resource_density := 1.0
var has_traders := false
var has_pirates := true
var has_disasters := false

var Game: Node3D = null
var PlayerStart: Node3D = null

@warning_ignore("unused_private_class_variable")
var _warning := false # DEBUG

func _ready() -> void:
	Config.load_config() # initialize with stored settings if available

	var window_mode = Config.window_mode
	var screen_resolution = Config.screen_resolution

	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (window_mode) else Window.MODE_WINDOWED
	set_screen_resolution(screen_resolution)

	set_audio_volumes()

	process_mode = Node.PROCESS_MODE_ALWAYS

func set_screen_resolution(screen_resolution: String) -> void:
	var resolution = screen_resolution.split("x")
	resolution = Vector2(int(resolution[0]), int(resolution[1]))
	get_window().set_size(resolution)
	#OS.center_window()
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func set_audio_volumes() -> void:
	Audio.set_master_volume(Config.master_volume)
	Audio.set_music_volume(Config.music_volume)
	Audio.set_effects_volume(Config.effects_volume)
	Audio.set_voice_volume(Config.voice_volume)

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
		#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED

		Config.window_mode = window_mode

		#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

	if event.is_action_pressed("quit_game"):
		get_tree().quit()
