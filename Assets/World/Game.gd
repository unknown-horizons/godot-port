extends Spatial
class_name Game

var is_game_running = false

var player_start: Spatial = null
var player: Control = null
#var players := [Control]

func _ready() -> void:
	Global.Game = self
	player_start = Global.PlayerStart
	
	Audio.play_entry_snd()

func _process(delta: float) -> void:
	if not is_game_running:
		start_game()
	
func start_game() -> void:
	if player_start:
		player = Player.new()
		player.faction = Global.faction

		add_child(player)
		
		# Assign starter ships
		var ships = player_start.get_children()
		ships[(randi() % ships.size())].faction = Global.faction
		for ship in ships:
			if ship.faction == Global.Factions.NONE:
				ship.queue_free()
		
		# Traders
		# TODO
		
		# Pirates
		if not Global.has_pirates:
			get_node("Pirate").queue_free()
		
		# Disasters
		# TODO

	is_game_running = true
