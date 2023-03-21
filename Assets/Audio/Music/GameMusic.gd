extends AudioStreamPlayer

# If this script somehow fails, "lose.ogg" will be played.

# Above could possibly be displayed inside a music player/list GUI.
var _music_files := []
var _music_streams := [] # Note: Does not show up in remote inspector.

func _ready() -> void:
	var dir := DirAccess.open("res://Assets/Audio/Music/Ambient")
	dir.list_dir_begin() # TODOGODOT4: Fill missing arguments https://github.com/godotengine/godot/pull/40547

	# Load all the files from the Ambient folder.
	while true:
		var file: String = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".ogg"):
			_music_files.append(file)

	for i in _music_files:
		_music_streams.append(load("Assets/Audio/Music/Ambient/" + i))

	# Always play a specific song when the game starts.
	stream = preload("res://Assets/Audio/Music/Ambient/newfrontier.ogg")
	play()

	randomize() # Godot will always generate the same random numbers otherwise.

func play_song_random() -> void:
	play_song_index(randi() % _music_streams.size())

func play_song_index(index: int) -> void:
	stop()
	stream = _music_streams[index]
	play()

# All the functions below are untested.

func add_song(file_name: String) -> void:
	_music_files.append(file_name)
	_music_streams.append(
			load("res://Assets/Audio/Music/Ambient/" + file_name))

func remove_song(file_name: String) -> void:
	remove_song_index(_music_files.find(file_name))

func remove_song_index(index: int) -> void:
	_music_streams.remove_at(index)
	_music_files.remove_at(index)
