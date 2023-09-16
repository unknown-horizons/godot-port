extends Node3D

signal notification(message_type: int, message_text: String)
signal game_speed_changed(new_game_speed: float)

const MAX_GAME_SPEED: float = 2.0

var is_game_running = false

var player_start: Node3D = null
var player: Player = null
#var players := [Player]

var ai_players = []

func _ready() -> void:
	Global.World = self
	player_start = Global.PlayerStart

	randomize()
	prints("[New Game]")
	Audio.play_entry_snd()

func _process(_delta: float) -> void:
	if not is_game_running:
		start_game()

func _input(event: InputEvent) -> void:
	# Only available during gameplay
	if event.is_action_pressed("time_speed_up"):
		get_viewport().set_input_as_handled()
		Engine.time_scale += clamp(.1, 0, 2)
		prints("Time Scale:", Engine.time_scale)
	elif event.is_action_pressed("time_slow_down"):
		get_viewport().set_input_as_handled()
		Engine.time_scale -= clamp(.1, 0, 2)
		prints("Time Scale:", Engine.time_scale)
	elif event.is_action_pressed("time_reset"):
		get_viewport().set_input_as_handled()
		Engine.time_scale = 1
		prints("Time Scale:", Engine.time_scale)
	elif event.is_action_pressed("pause_scene"):
		get_viewport().set_input_as_handled()
		get_tree().paused = !get_tree().paused
		prints("paused:", get_tree().paused)
	elif event.is_action_pressed("restart_scene"):
		get_viewport().set_input_as_handled()
		#warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	elif event.is_action_pressed("debug_raise_notification"):
		get_viewport().set_input_as_handled()
		# Notification test (press N within a game session)
		emit_signal("notification", 3, "This is a test notification.")

func start_game() -> void:
	if player_start:
		player = Player.new()
		player.faction = Global.faction

		add_child(player)

		connect("notification", Callable(player, "_on_Game_notification"))

		# Assign player starter ship
		var ships: Array[Node] = player_start.ships
		ships[(randi() % ships.size())].faction = player.faction

		var factions: Array = range(1, 15)
		factions.remove_at(factions.find(player.faction)) # Remove occupied faction from array.

		# Assign AI starter ships
		ai_players.resize(Global.ai_players)
		if ai_players.size() > 0: printt("ai_player", "ship")
		for ai_player in range(ai_players.size()):
			ai_players[ai_player] = factions[randi() % factions.size()] # Assign random faction to AI player.
			factions.remove_at(factions.find(ai_players[ai_player])) # Remove occupied faction from array.

			for ship in ships:
				if ship.faction == Global.Faction.NONE:
					ship.faction = ai_players[ai_player]
					printt(ai_players[ai_player], ship.name)
					break

		# Remove any ships left over
		for ship in ships:
			if ship.faction == Global.Faction.NONE:
				ship.queue_free()

		# Traders
		if not Global.has_traders:
			var traders := get_node("Traders")
			if traders != null:
				traders.queue_free()

		# Pirates
		if not Global.has_pirates:
			var pirates := get_node("Pirates")
			if pirates != null:
				pirates.queue_free()

		# Disasters
		if not Global.has_disasters:
			pass # TODO

	is_game_running = true

func set_game_speed(game_speed: float) -> void:
	Engine.time_scale = clamp(game_speed, 0.0, MAX_GAME_SPEED)
	print_debug("Game speed changed to ", Engine.time_scale)
	emit_signal("game_speed_changed", Engine.time_scale)
