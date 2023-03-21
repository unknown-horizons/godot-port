@tool
extends BookMenu
class_name OptionsUI

# Screen resolution choices
const SCREEN_RESOLUTIONS = [
	"800x600",
	"1024x768",
	"1280x1024",
	"1280x720",
	"1280x800",
	"1360x768",
	"1366x768",
	"1440x900",
	"1600x900",
	"1680x1050",
	"1920x1200",
	"1920x1080",
	"2560x1080",
	"2560x1440",
	"3440x1440",
	"3840x2160",
]

@onready var settings = {
	"AutosaveInterval": find_child("AutosaveInterval") as HSliderEx,
	"NumberOfAutosaves": find_child("NumberOfAutosaves") as HSliderEx,
	"NumberOfQuicksaves": find_child("NumberOfQuicksaves") as HSliderEx,

	"PlayerName": find_child("PlayerName") as LineEditEx,
	"GameLanguage": find_child("GameLanguage") as OptionButtonEx,

	"ScrollAtMapEdge": find_child("ScrollAtMapEdge") as CheckBoxEx,
	"CursorCenteredZoom": find_child("CursorCenteredZoom") as CheckBoxEx,
	"MiddleMouseButtonPan": find_child("MiddleMouseButtonPan") as CheckBoxEx,
	"MouseSensitivity": find_child("MouseSensitivity") as HSliderEx,

	"WindowMode": find_child("WindowMode") as OptionButtonEx,
	"ScreenResolution": find_child("ScreenResolution") as OptionButtonEx,

	"MasterVolume": find_child("MasterVolume") as HSliderEx,
	"MusicVolume": find_child("MusicVolume") as HSliderEx,
	"EffectsVolume": find_child("EffectsVolume") as HSliderEx,
	"VoiceVolume": find_child("VoiceVolume") as HSliderEx,
}

func _ready() -> void:
	super()

	if Engine.is_editor_hint():
		return

	# Autosaving
	settings["AutosaveInterval"].value = Config.autosave_interval
	settings["NumberOfAutosaves"].value = Config.number_of_autosaves
	settings["NumberOfQuicksaves"].value = Config.number_of_quicksaves

	# Player name
	settings["PlayerName"].text = Config.player_name

	# Populate with languages
	settings["GameLanguage"].options = Global.LANGUAGES_READABLE.values()
	for language_index in Global.LANGUAGES.size():
		if Config.language == Global.LANGUAGES[language_index]:
			settings["GameLanguage"].selected = language_index

	# Mouse settings
	settings["ScrollAtMapEdge"].checked = Config.scroll_at_map_edge
	settings["CursorCenteredZoom"].checked = Config.cursor_centered_zoom
	settings["MiddleMouseButtonPan"].checked = Config.middle_mouse_button_pan
	settings["MouseSensitivity"].value = Config.mouse_sensitivity

	# Window mode
	settings["WindowMode"].options = Global.WINDOW_MODES.values()
	settings["WindowMode"].selected = Config.window_mode
	settings["WindowMode"].item_selected.connect(Callable(self, "_on_WindowMode_item_selected"))
	settings["WindowMode"].item_selected.emit(Config.window_mode)

	# Populate with available resolutions
	settings["ScreenResolution"].options = SCREEN_RESOLUTIONS
	for screen_resolution_index in SCREEN_RESOLUTIONS.size():
		if Config.screen_resolution == SCREEN_RESOLUTIONS[screen_resolution_index]:
			settings["ScreenResolution"].selected = screen_resolution_index
	settings["ScreenResolution"].item_selected.connect(Callable(self, "_on_ScreenResolution_item_selected"))

	# Audio parameters
	settings["MasterVolume"].value = Config.master_volume
	settings["MasterVolume"].value_changed.connect(Callable(self, "_on_MasterVolume_value_changed"))

	settings["MusicVolume"].value = Config.music_volume
	settings["MusicVolume"].value_changed.connect(Callable(self, "_on_MusicVolume_value_changed"))

	settings["EffectsVolume"].value = Config.effects_volume
	settings["EffectsVolume"].value_changed.connect(Callable(self, "_on_EffectsVolume_value_changed"))

	settings["VoiceVolume"].value = Config.voice_volume
	settings["VoiceVolume"].value_changed.connect(Callable(self, "_on_VoiceVolume_value_changed"))

func populate_dropdown(dropdown: OptionButton, items: Dictionary) -> void:
	for item in items.values():
		dropdown.add_item(item)

func _on_WindowMode_item_selected(index) -> void:
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (index) else Window.MODE_WINDOWED
	settings["ScreenResolution"].get_node("OptionButton").disabled = not index == Global.WindowMode.WINDOWED
	Global.set_screen_resolution(Config.screen_resolution)

func _on_ScreenResolution_item_selected(index) -> void:
	if index != -1:
		Global.set_screen_resolution(settings["ScreenResolution"].options[index])

func _on_MasterVolume_value_changed(slider_value: float) -> void:
	Audio.set_master_volume(slider_value)

func _on_MusicVolume_value_changed(slider_value: float) -> void:
	Audio.set_music_volume(slider_value)

func _on_EffectsVolume_value_changed(slider_value: float) -> void:
	Audio.set_effects_volume(slider_value)

func _on_VoiceVolume_value_changed(slider_value: float) -> void:
	Audio.set_voice_volume(slider_value)

func _on_DeleteButton_pressed() -> void:
	print("TODO: Confirm action (modal dialog) before resetting everything.")
	Config.reset_to_factory_settings()
	_ready()

	super()

func _on_CancelButton_pressed() -> void:
	Config.load_config()

	# Revert temporary screen resolution change
	Global.set_screen_resolution(Config.screen_resolution)
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (Config.window_mode) else Window.MODE_WINDOWED

	# revert volume changes
	_ready()

	super()

func _on_OKButton_pressed() -> void:
	Config.autosave_interval = settings["AutosaveInterval"].value
	Config.number_of_autosaves = settings["NumberOfAutosaves"].value
	Config.number_of_quicksaves = settings["NumberOfQuicksaves"].value

	Config.player_name = settings["PlayerName"].text
	Config.language = Global.LANGUAGES[settings["GameLanguage"].selected]

	Config.scroll_at_map_edge = settings["ScrollAtMapEdge"].checked
	Config.cursor_centered_zoom = settings["CursorCenteredZoom"].checked
	Config.middle_mouse_button_pan = settings["MiddleMouseButtonPan"].checked
	Config.mouse_sensitivity = settings["MouseSensitivity"].value

	Config.window_mode = settings["WindowMode"].selected
	Config.screen_resolution = SCREEN_RESOLUTIONS[settings["ScreenResolution"].selected]

	Config.master_volume = settings["MasterVolume"].value
	Config.music_volume = settings["MusicVolume"].value
	Config.effects_volume = settings["EffectsVolume"].value
	Config.voice_volume = settings["VoiceVolume"].value

	var saved = Config.save_config()
	if saved != OK:
		print("Could not save config!")

	super()
