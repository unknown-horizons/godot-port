@tool
extends Unit
class_name Ship

# Generic properties
@export_range(0, 250) var max_health := 150

# Navigational properties
@export_range(0, 8) var radius := 5
@export_range(0, 12) var velocity := 12

# Storage capacity
@export_range(0, 120) var storage_limit := 120
@export_range(0, 4) var num_of_slots := 4

func _ready() -> void:
	super()
	add_to_group("units")
	# DEBUG
	$Billboard.vframes = 2
	$Billboard.hframes = 4

func _process(delta: float) -> void:
	update_path()

	recalculate_directions()
	animate_movement()
	update_faction_color()

	if is_moving:
		translate(Utils.map_2_to_3(move_vector.normalized()) * delta * velocity / 4)

func update_faction_color() -> void:
	pass
