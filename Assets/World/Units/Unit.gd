tool
extends WorldThing
class_name Unit

signal position_changed

# All units are 8-directional.
# Vector items are aligned according to the default camera rotation (-45°)
# and must be shifted increasingly by 2 for each further camera rotation.
#
# DIRECTION[direction + rotation_offset]
#
# Example: to keep RIGHT direction for each camera angle
#
#    -45° -> DIRECTION[index + 0] -> Vector3( 1, 0,  1)
#     45° -> DIRECTION[index + 2] -> Vector3(-1, 0,  1)
#    135° -> DIRECTION[index + 4] -> Vector3(-1, 0, -1)
#   -135° -> DIRECTION[index + 6] -> Vector3( 1, 0, -1)

const DIRECTION = [
	Vector3( 1, 0,  1), # RIGHT
	Vector3( 0, 0,  1), # DOWN_RIGHT
	Vector3(-1, 0,  1), # DOWN
	Vector3(-1, 0,  0), # DOWN_LEFT
	Vector3(-1, 0, -1), # LEFT
	Vector3( 0, 0, -1), # UP_LEFT
	Vector3( 1, 0, -1), # UP
	Vector3( 1, 0,  0)] # UP_RIGHT

#warning-ignore-all:unused_class_variable

# Generic properties
export var unit_name = "Untitled" # user defined name for the unit
export(Global.Faction) var faction := 0 setget set_faction

# Pathfinding
var path = []
var path_index = 0

var move_vector = Vector3()

# Sprite rotation
var direction = -1 # for non-animated movements, this is the frame_index
var rotation_offset = 0
var rotation_index

onready var rotation_y: Spatial = get_node_or_null("/root/World/PlayerCamera/RotationY") as Spatial
onready var _as_map: Spatial = get_node_or_null("/root/World/AStarMap") as Spatial

var is_moving = false

func _ready() -> void:
	direction = rotation_degree

func set_faction(new_faction: int) -> void:
	faction = new_faction

func select() -> void:
	Audio.play_snd_click()
	$SelectionRing.visible = true
	# TODO: Highlighting effect
	#$AnimationPlayer.play("selected")

func deselect() -> void:
	$SelectionRing.visible = false
	#$AnimationPlayer.stop()

func move_to(target_pos: Vector3) -> void:
	path = _as_map.get_gm_path(global_transform.origin, target_pos)
	path_index = 0

func update_path() -> void:
	var move_vec: Vector3
	var dir_vec: Vector3
	var dir = 0

	if path_index < path.size():
		move_vec = (path[path_index] - global_transform.origin)
		if move_vec.length() < 1: # set next target node or proceed to the current one
			path_index += 1
			emit_signal("position_changed", global_transform.origin)# + move_vector)
		else:
			is_moving = true

			dir_vec = Vector3(
								sign(round(move_vec.x)),
								sign(round(move_vec.y)),
								sign(round(move_vec.z))
								)
			dir = DIRECTION.find(dir_vec)
			#prints("Direction:", dir)

			move_vector = move_vec
			direction = dir
	else:
		path_index = 0
		path = []
		is_moving = false

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

func animate_movement() -> void:
	# For editor preview
	if Engine.is_editor_hint():
		return

	update_rotation()

	set_rotation_degree(rotation_index)

# =================================================
# TODO: For later use, hover effect, selection etc.
# =================================================
func _on_Area_input_event(_camera, _event, _click_position, _click_normal, _shape_idx):
	#print("_on_Area_input_event(...)")
	#print("{0} {1} {2} {3} {4}".format([camera, event, click_position, click_normal, shape_idx]))
	pass

func _on_Area_mouse_entered():
	#print("_on_Area_mouse_entered()")
	pass

func _on_Area_mouse_exited():
	#print("_on_Area_mouse_exited()")
	pass
