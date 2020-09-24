tool
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

onready var settings = {
	"AutosaveInterval": find_node("AutosaveInterval") as HSliderEx,
	"NumberOfAutosaves": find_node("NumberOfAutosaves") as HSliderEx,
	"NumberOfQuicksaves": find_node("NumberOfQuicksaves") as HSliderEx,

	"PlayerName": find_node("PlayerName") as LineEditEx,
	"GameLanguage": find_node("GameLanguage") as OptionButtonEx,

	"ScrollAtMapEdge": find_node("ScrollAtMapEdge") as CheckBoxEx,
	"CursorCenteredZoom": find_node("CursorCenteredZoom") as CheckBoxEx,
	"MiddleMouseButtonPan": find_node("MiddleMouseButtonPan") as CheckBoxEx,
	"MouseSensitivity": find_node("MouseSensitivity") as HSliderEx,

	"WindowMode": find_node("WindowMode") as OptionButtonEx,
	"ScreenResolution": find_node("ScreenResolution") as OptionButtonEx,

	"MasterVolume": find_node("MasterVolume") as HSliderEx,
	"MusicVolume": find_node("MusicVolume") as HSliderEx,
	"EffectsVolume": find_node("EffectsVolume") as HSliderEx,
	"VoiceVolume": find_node("VoiceVolume") as HSliderEx,
}

func _ready() -> void:
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
	settings["WindowMode"].connect("item_selected", self, "_on_WindowMode_item_selected")
	settings["WindowMode"].emit_signal("item_selected", Config.window_mode)

	# Populate with available resolutions
	settings["ScreenResolution"].options = SCREEN_RESOLUTIONS
	for screen_resolution_index in SCREEN_RESOLUTIONS.size():
		if Config.screen_resolution == SCREEN_RESOLUTIONS[screen_resolution_index]:
			settings["ScreenResolution"].selected = screen_resolution_index
	settings["ScreenResolution"].connect("item_selected", self, "_on_ScreenResolution_item_selected")

	settings["MasterVolume"].value = Config.master_volume
	settings["MasterVolume"].connect("value_changed", self, "_on_MasterVolume_value_changed")

	settings["MusicVolume"].value = Config.music_volume
	settings["MusicVolume"].connect("value_changed", self, "_on_MusicVolume_value_changed")

	settings["EffectsVolume"].value = Config.effects_volume
	settings["EffectsVolume"].connect("value_changed", self, "_on_EffectsVolume_value_changed")

	settings["VoiceVolume"].value = Config.voice_volume
	settings["VoiceVolume"].connect("value_changed", self, "_on_VoiceVolume_value_changed")

func populate_dropdown(dropdown: OptionButton, items: Dictionary) -> void:
	for item in items.values():
		dropdown.add_item(item)

func _on_WindowMode_item_selected(index) -> void:
	OS.window_fullscreen = index
	settings["ScreenResolution"].get_node("OptionButton").disabled = not index == Global.WindowMode.WINDOWED
	Global.set_screen_resolution(Config.screen_resolution)

func _on_ScreenResolution_item_selected(index) -> void:
	if index != -1:
		Global.set_screen_resolution(settings["ScreenResolution"].options[index])

func _on_MasterVolume_value_changed(slider_value: float) -> void:
	prints("TODO: Set MasterVolume:", slider_value)

func _on_MusicVolume_value_changed(slider_value: float) -> void:
	prints("TODO: Set MusicVolume:", slider_value)

func _on_EffectsVolume_value_changed(slider_value: float) -> void:
	prints("TODO: Set EffectsVolume:", slider_value)

func _on_VoiceVolume_value_changed(slider_value: float) -> void:
	prints("TODO: Set VoiceVolume:", slider_value)

func _on_DeleteButton_pressed() -> void:
	print("TODO: Confirm action (modal dialog) before resetting everything.")
	Config.reset_to_factory_settings()
	_ready()

	._on_DeleteButton_pressed()

func _on_CancelButton_pressed() -> void:
	Config.load_config()

	# Revert temporary screen resolution change
	Global.set_screen_resolution(Config.screen_resolution)
	OS.window_fullscreen = Config.window_mode

	._on_CancelButton_pressed()

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

	._on_OKButton_pressed()
