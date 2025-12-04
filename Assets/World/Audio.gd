extends AudioStreamPlayer

const SOUNDS = {
	# Events/Scenario
	"lose": preload("res://Assets/Audio/Sounds/Events/Scenario/lose.ogg"),
	"win": preload("res://Assets/Audio/Sounds/Events/Scenario/win.ogg"),

	# Events
	"new_era": preload("res://Assets/Audio/Sounds/Events/new_era.ogg"),
	"new_settlement": preload("res://Assets/Audio/Sounds/Events/new_settlement.ogg"),

	# .
	"build": preload("res://Assets/Audio/Sounds/build.ogg"),
	"chapel": preload("res://Assets/Audio/Sounds/chapel.ogg"),
	"click": preload("res://Assets/Audio/Sounds/click.ogg"),
	"flippage": preload("res://Assets/Audio/Sounds/flippage.ogg"),
	"invalid": preload("res://Assets/Audio/Sounds/invalid.ogg"),
	"lumberjack": preload("res://Assets/Audio/Sounds/lumberjack.ogg"),
	"lumberjack_long": preload("res://Assets/Audio/Sounds/lumberjack_long.ogg"),
	"main_square": preload("res://Assets/Audio/Sounds/main_square.ogg"),
	"refresh": preload("res://Assets/Audio/Sounds/refresh.ogg"),
	"sheepfield": preload("res://Assets/Audio/Sounds/sheepfield.ogg"),
	"ships_bell": preload("res://Assets/Audio/Sounds/ships_bell.ogg"),
	"smith": preload("res://Assets/Audio/Sounds/smith.ogg"),
	"stonemason": preload("res://Assets/Audio/Sounds/stonemason.ogg"),
	"success": preload("res://Assets/Audio/Sounds/success.ogg"),
	"tavern": preload("res://Assets/Audio/Sounds/tavern.ogg"),
	"warehouse": preload("res://Assets/Audio/Sounds/warehouse.ogg"),
	"windmill": preload("res://Assets/Audio/Sounds/windmill.ogg"),

	# TODO: Possibly into distinct const?
	"de_0": preload("res://Assets/Audio/Voice/de/0/NewWorld/0.ogg"),
	"de_1": preload("res://Assets/Audio/Voice/de/0/NewWorld/1.ogg"),
	"de_2": preload("res://Assets/Audio/Voice/de/0/NewWorld/2.ogg"),
	"de_3": preload("res://Assets/Audio/Voice/de/0/NewWorld/3.ogg"),

	"en_0": preload("res://Assets/Audio/Voice/en/0/NewWorld/0.ogg"),
	"en_1": preload("res://Assets/Audio/Voice/en/0/NewWorld/1.ogg"),
	"en_2": preload("res://Assets/Audio/Voice/en/0/NewWorld/2.ogg"),
	"en_3": preload("res://Assets/Audio/Voice/en/0/NewWorld/3.ogg"),

	"fr_0": preload("res://Assets/Audio/Voice/fr/0/NewWorld/0.ogg"),
	"fr_1": preload("res://Assets/Audio/Voice/fr/0/NewWorld/1.ogg"),
	"fr_2": preload("res://Assets/Audio/Voice/fr/0/NewWorld/2.ogg"),
	"fr_3": preload("res://Assets/Audio/Voice/fr/0/NewWorld/3.ogg"),
}

var asp_click = AudioStreamPlayer.new()
var asp_build = AudioStreamPlayer.new()
var asp_voice = AudioStreamPlayer.new()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	asp_click.bus = "Effects"
	asp_build.bus = "Effects"
	asp_voice.bus = "Voice"

	asp_click.stream = SOUNDS["click"]
	asp_build.stream = SOUNDS["build"]

func play_snd(snd_name: String, stream: AudioStream = null) -> void:
	var asp: AudioStreamPlayer = {
		"click": asp_click,
		"build": asp_build,
		"voice": asp_voice
	}.get(snd_name)

	# If a distinct AudioStreamPlayer exists for the requested sound,
	# use that one
	if asp != null:
		if stream: # Currently only used to pass different voice messages
			asp.stream = stream
		if asp.name.is_empty():
			add_child(asp)
		asp.play()
		#print_debug("Playing {0}".format([snd_name]))

	# Otherwise play it through the generic AudioStreamPlayer
	elif SOUNDS[snd_name]:
		self.stream = SOUNDS[snd_name]
		#if not name: # "@@2"
		#	add_child(self)
		play()
		#print_debug("Playing {0}".format([snd_name]))
	else:
		printerr("Sound {0} not found.".format([snd_name]))

func play_snd_click() -> void:
	play_snd("click")

func play_snd_fail() -> void:
	play_snd("build")

func play_snd_voice(voice_code: String) -> void:
	play_snd("voice", SOUNDS[voice_code])

func play_entry_snd() -> void:
	asp_voice.stream = SOUNDS["{0}_{1}".format([Config.language, randi() % 4])]
	if asp_voice.name.is_empty():
		add_child(asp_voice)
	asp_voice.play()

func set_volume(volume: float, bus_name: String) -> void:
	var index = AudioServer.get_bus_index(bus_name)
	print("Set volume for bus {0}({1}): {2}".format([bus_name, index, volume]))
	AudioServer.set_bus_volume_db(index, linear_to_db(volume / 100.0))

func set_master_volume(volume: float) -> void:
	set_volume(volume, "Master")

func set_voice_volume(volume: float) -> void:
	set_volume(volume, "Voice")

func set_effects_volume(volume: float) -> void:
	set_volume(volume, "Effects")

func set_music_volume(volume: float) -> void:
	set_volume(volume, "Music")
