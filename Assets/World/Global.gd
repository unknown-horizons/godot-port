tool
extends Node
class_name Global

enum Factions {
	NONE,
	RED,
	BLUE,
	GREEN,
	ORANGE,
	PURPLE,
	CYAN,
	YELLOW,
	PINK,
	TEAL,
	LEMON,
	BORDEAUX,
	WHITE,
	GRAY,
	BLACK
}

const FACTIONS = [
	"None",
	"Red",
	"Blue",
	"Green",
	"Orange",
	"Purple",
	"Cyan",
	"Yellow",
	"Pink",
	"Teal",
	"Lemon",
	"Bordeaux",
	"White",
	"Gray",
	"Black"
]

const COLOR = [
				Color(0,       0,    0, 0),
				Color(1,    0.04, 0.04, 1),
				Color(0,    0.28, 0.71, 1),
				Color(0,    0.63, 0.09, 1),
				Color(0.88,  0.4,    0, 1),
				Color(0.50,    0, 0.50, 1),
				Color(0,       1,    1, 1),
				Color(1,    0.84,    0, 1),
				Color(1,       0,    1, 1),
				Color(0,    0.57, 0.55, 1),
				Color(0,       1,    0, 1),
				Color(0.59, 0.02, 0.16, 1),
				Color(1,       1,    1, 1),
				Color(0.50, 0.50, 0.50, 1),
				Color(0,       0,    0, 1)
				];

const FACTION_COLOR_NONE =\
	preload("res://Assets/Player/FactionColor/FactionColorNone.tres")
const FACTION_COLOR_RED =\
	preload("res://Assets/Player/FactionColor/FactionColorRed.tres")
const FACTION_COLOR_BLUE =\
	preload("res://Assets/Player/FactionColor/FactionColorBlue.tres")
const FACTION_COLOR_GREEN =\
	preload("res://Assets/Player/FactionColor/FactionColorGreen.tres")
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
const FACTION_COLOR_LEMON =\
	preload("res://Assets/Player/FactionColor/FactionColorLemon.tres")
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
	FACTION_COLOR_GREEN,
	FACTION_COLOR_ORANGE,
	FACTION_COLOR_PURPLE,
	FACTION_COLOR_CYAN,
	FACTION_COLOR_YELLOW,
	FACTION_COLOR_PINK,
	FACTION_COLOR_TEAL,
	FACTION_COLOR_LEMON,
	FACTION_COLOR_BORDEAUX,
	FACTION_COLOR_WHITE,
	FACTION_COLOR_GRAY,
	FACTION_COLOR_BLACK
]

# System variables
var language = "en"

# -------
var game_type = "FreePlay"
var player_name = "Unknown Traveller"
var faction = 1
var map: PackedScene
var ai_players = 3
var resource_density := 1.0
var has_traders := false
var has_pirates := true
var has_disasters := false
# -------
var Game: Spatial = null
var PlayerStart: MeshInstance = null

#var specifications = {
#
#}

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS

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
			get_tree().reload_current_scene()
	
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

	if event.is_action_pressed("quit_game"):
		get_tree().quit()
