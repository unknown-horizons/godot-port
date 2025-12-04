extends Node

const CONFIG_FILE = "user://unknown_horizons.ini"

# System variables
var config

# Graphic variables
var window_mode = Global.WindowMode.WINDOWED
var screen_resolution := "1600x900"

# Game variables
var player_name := "Unknown Traveller"
var language = "en"

# Autosave
var autosave_interval := 10
var number_of_autosaves := 10
var number_of_quicksaves := 10

# Mouse controls
var scroll_at_map_edge := true
var cursor_centered_zoom := false
var middle_mouse_button_pan := true
var mouse_sensitivity := 3.0

# Audio/Sound
var master_volume := 50.0
var music_volume := 75.0
var effects_volume := 80.0
var voice_volume := 80.0

#var uninterrupted_building := false
#var auto_unload_ship := true

# Each setting with their respective initial value
var settings = {
	"System": {
		"window_mode": window_mode,
		"screen_resolution": screen_resolution,
	},
	"Game": {
		"player_name": player_name,
		"language": language,
	},
	"Autosave": {
		"autosave_interval": autosave_interval,
		"number_of_autosaves": number_of_autosaves,
		"number_of_quicksaves": number_of_quicksaves,
	},
	"Mouse": {
		"scroll_at_map_edge": scroll_at_map_edge,
		"cursor_centered_zoom": cursor_centered_zoom,
		"middle_mouse_button_pan": middle_mouse_button_pan,
		"mouse_sensitivity": mouse_sensitivity,
	},
	"Sound": {
		"master_volume": master_volume,
		"music_volume": music_volume,
		"effects_volume": effects_volume,
		"voice_volume": voice_volume,
	}
}

func create_config_if_not_existing() -> ConfigFile:
	config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err != OK:
		var saved = save_config()
		if saved != OK:
			print("The config could not be saved!")
			get_tree().quit()

	return config

func load_config() -> void:
	config = create_config_if_not_existing()
	var err = config.load(CONFIG_FILE)
	if err != OK:
		print("Could not load config.")
		get_tree().quit()

	load_config_values(settings)

func load_config_value(section: String, key: String, default) -> void:
	set(key, config.get_value(section, key, default))

func load_config_values(sections: Dictionary) -> void:
	#prints("Loading/Initializing settings...")
	for section in sections.keys():
		for key in sections[section]:
			var value = sections[section][key]
			load_config_value(section, key, value)

			#prints(section, key, value)

func save_config() -> int:
	save_config_values(settings)

	return config.save(CONFIG_FILE)

func save_config_value(section: String, key: String, value) -> void:
	config.set_value(section, key, value)

func save_config_values(sections: Dictionary) -> void:
	for section in sections.keys():
		for key in sections[section]:
			save_config_value(section, key, get(key))

func reset_to_factory_settings() -> void:
	#prints("Load default settings...")
	var sections = settings
	for section in sections.keys():
		for key in sections[section]:
			var value = sections[section][key]
			set(key, value)

			#prints(section, key, value)
