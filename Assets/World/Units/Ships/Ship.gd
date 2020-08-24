tool
extends Unit
class_name Ship

#warning-ignore-all:unused_class_variable

# Generic properties
export(int, 250) var max_health = 150

# Navigational properties
export(int, 8) var radius = 5
export(int, 12) var velocity = 12

# Storage capacity
export(int, 120) var storage_limit = 120
export(int, 4) var num_of_slots = 4

func _ready() -> void:
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
		translate(move_vector.normalized() * delta * velocity / 4)

func update_faction_color() -> void:
	pass
