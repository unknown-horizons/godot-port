@tool
extends WorldThing
class_name Unit

## Base class for all units.

signal position_changed

#const Global = preload("res://Assets/World/Global.gd") TODO: Remove if possible
const Buoy = preload("res://Assets/World/Buoy/Buoy.tscn")

# All units are 8-directional.
# Vector items are aligned according to the default camera rotation (-45°)
# and must be shifted increasingly by 2 for each further camera rotation.
#
# DIRECTION[direction + rotation_offset]
#
# Example: to keep RIGHT direction for each camera angle
#
#    -45° -> DIRECTION[index + 0] -> Vector2( 1,  1)
#     45° -> DIRECTION[index + 2] -> Vector2(-1,  1)
#    135° -> DIRECTION[index + 4] -> Vector2(-1, -1)
#   -135° -> DIRECTION[index + 6] -> Vector2( 1, -1)

const DIRECTION = [
	Vector2( 1,  1), # RIGHT
	Vector2( 0,  1), # DOWN_RIGHT
	Vector2(-1,  1), # DOWN
	Vector2(-1,  0), # DOWN_LEFT
	Vector2(-1, -1), # LEFT
	Vector2( 0, -1), # UP_LEFT
	Vector2( 1, -1), # UP
	Vector2( 1,  0)] # UP_RIGHT

#warning-ignore-all:unused_class_variable

# Generic properties
@export var unit_name = "Untitled" # user defined name for the unit
@export var faction: Global.Faction = 0 : set = set_faction
var health = -1 # health must be set or it won't auto destroy itself

# Pathfinding
var path = []
var path_index = 0

var move_vector = Vector2()

# Sprite2D rotation
var direction = -1 # for non-animated movements, this is the frame_index
var rotation_offset = 0
var rotation_index

var buoy: Buoy = null

@onready var rotation_y: Node3D = get_node_or_null("/root/World/PlayerCamera/RotationY") as Node3D
@onready var _as_map: Node3D = get_node_or_null("/root/World/AStarMap") as Node3D
@onready var world: Node3D = get_node_or_null("/root/World") as Node3D

var is_moving = false

func _ready() -> void:
	super()

	direction = rotation_degree

func set_faction(new_faction: int) -> void:
	faction = new_faction

func select() -> void:
	Audio.play_snd_click()
	%SelectionRing.visible = true
	# TODO: Highlighting effect
	#$AnimationPlayer.play("selected")
	if buoy:
		buoy.visible = true

func deselect() -> void:
	%SelectionRing.visible = false
	if buoy:
		buoy.visible = false
	#$AnimationPlayer.stop()

func move_to(target_pos: Vector2) -> void:
	path = _as_map.get_tilemap_path(Utils.map_3_to_2(global_transform.origin), target_pos)
	path_index = 0
	if faction == world.player.faction and not path.is_empty():
		# Only show when the unit actually moves
		if path.size() > 2:
			create_buoy(path[-1])
			Audio.play_snd_click()

func update_path() -> void:
	var move_vec: Vector2
	var dir_vec: Vector2
	var dir = 0

	if path_index < path.size():
		move_vec = (path[path_index] - Utils.map_3_to_2(global_transform.origin))
		if move_vec.length() < 1: # set next target node or proceed to the current one
			path_index += 1
			emit_signal("position_changed", global_transform.origin)# + move_vector)
		else:
			is_moving = true

			dir_vec = Vector2(sign(round(move_vec.x)), sign(round(move_vec.y)))
			dir = DIRECTION.find(dir_vec)
			#prints("Direction:", dir)

			move_vector = move_vec
			direction = dir
	else:
		path_index = 0
		path = []
		is_moving = false
		destroy_buoy()

func recalculate_directions() -> void:
	if Engine.is_editor_hint():
		return

	if rotation_y == null:
		rotation_y = get_node("/root/World/PlayerCamera/RotationY")

	match int(round(rotation_y.rotation_degrees.y)):
		-45:
			rotation_offset = 0
		45:
			rotation_offset = 2
		135:
			rotation_offset = 4
		-135:
			rotation_offset = 6

func update_rotation() -> void:
	#prints("direction:", direction)
	#prints("rotation_offset:", rotation_offset)
	rotation_index = wrapi(direction + rotation_offset, 0, _billboard.hframes * _billboard.vframes)

func create_buoy(target_pos: Vector2) -> void:
	if is_instance_valid(buoy):
		buoy.queue_free()
	buoy = Buoy.instantiate()
	buoy.set_position(Utils.map_2_to_3(target_pos))
	buoy.translate(Vector3(0, 0.2, 0))
	world.add_child(buoy)

func destroy_buoy() -> void:
	if is_instance_valid(buoy):
		buoy.queue_free()
	buoy = null

func animate_movement() -> void:
	# For editor preview
	if Engine.is_editor_hint():
		return

	update_rotation()

	set_rotation_degree(rotation_index)

func take_damage(damage: int) -> void:
	if (health - damage) < 0:
		health = 0
	else:
		health -= damage

	if health == 0:
		queue_free()
