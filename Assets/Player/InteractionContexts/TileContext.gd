extends InteractionContext
class_name TileContext

signal tiles_changed(scaffold_tiles, can_built) # Array, bool

const CURSOR_DEFAULT = preload("res://Assets/UI/Images/Cursors/cursor.png")
const CURSOR_ATTACK = preload("res://Assets/UI/Images/Cursors/cursor_attack.png")
const CURSOR_PIPETTE = preload("res://Assets/UI/Images/Cursors/cursor_pipette.png")
const CURSOR_RENAME = preload("res://Assets/UI/Images/Cursors/cursor_rename.png")
const CURSOR_TEAR = preload("res://Assets/UI/Images/Cursors/cursor_tear.png")

const PHANTOM_TILE_TEXTURE = preload("res://Assets/World/Buildings/Sailors/Streets/Sprites/trail_single.png")

onready var streets: GridMap = get_node("/root/World/AStarMap/Streets") as GridMap
var streets_phantom: GridMap

var m_pos: Vector2

var phantom_tile: Sprite3D

var last_cell_pos: Vector3

var is_drawing := false
var draw_path := []
var aborted := false

func _ready() -> void:
	# TODO: Implement TileContext without having it automatically enabled.
	# For now, comment both lines below to test tiling and revert then back.
	set_process(false)
	return

	var material = SpatialMaterial.new()
	material.flags_transparent = true
	material.flags_no_depth_test = true
	material.params_billboard_mode = SpatialMaterial.BILLBOARD_ENABLED
	material.albedo_texture = PHANTOM_TILE_TEXTURE

	phantom_tile = Sprite3D.new()
	phantom_tile.texture = PHANTOM_TILE_TEXTURE
	phantom_tile.pixel_size = 0.02
	phantom_tile.material_override = material
	add_child(phantom_tile)
	Input.set_custom_mouse_cursor(CURSOR_TEAR, Input.CURSOR_ARROW)

	connect("tiles_changed", streets, "update_tiles")

func _process(_delta: float) -> void:
	m_pos = _player_camera.get_viewport().get_mouse_position()

	var cell_pos = get_tile_under_mouse(m_pos)

	if cell_pos == last_cell_pos:
		return

	show_phantom_tile(cell_pos)

	if is_drawing:
		#print_debug("Check if tiling is executed on valid terrain")
		if draw_path.size() >= 4 and cell_pos == draw_path[-4] or \
		not cell_pos in streets.get_used_cells(): # free cell?
			draw_path.append(cell_pos)
			set_cell_item(cell_pos, 0)
			emit_signal("tiles_changed", draw_path)
		else: # occupied cell
			if draw_path.size() > 1:
				if cell_pos == draw_path[-2]:
					#draw_path.remove(draw_path.size() - 1)
					var cell_to_be_removed = draw_path.pop_back()
					if not cell_to_be_removed in draw_path:
						set_cell_item(cell_to_be_removed, -1)
					emit_signal("tiles_changed", draw_path)

	prints("cell_pos:", cell_pos, "last_cell_pos:", last_cell_pos)
	last_cell_pos = cell_pos
	prints(" === draw_path:", draw_path)

func show_phantom_tile(cell_pos: Vector3) -> void:
	phantom_tile.translation = streets.map_to_world(cell_pos.x, 0, cell_pos.z)

func get_tile_under_mouse(m_pos: Vector2) -> Vector3:
	var raycast_position = _player_camera.raycast_from_mouse(m_pos, 1).position

	var cell_pos = streets.world_to_map(raycast_position)
	cell_pos.y = 0 # Stick to layer 0 at all times to prevent "falling through" the map

	return cell_pos

func handle_tiles(raycast_position: Vector3) -> void:
	var cell_pos = streets.world_to_map(raycast_position)
	#var cell_item = streets.get_cell_item(cell_pos.x, 0, cell_pos.z)
	#var mesh_library = streets.mesh_library
	#var item_name = mesh_library.get_item_name(cell_item)

	prints("cell pos:", cell_pos)
	#prints("cell item:", cell_item)
	#prints("mesh_library:", mesh_library.resource_name)
	#prints("item_mesh:", item_name)

	#prints("orientation:", streets.get_cell_item_orientation(cell_pos.x, 0, cell_pos.z))

func set_tile(cell_pos: Vector3) -> void:
	streets.set_cell_item(cell_pos.x, 0, cell_pos.z, 0)

func unset_tile(cell_pos: Vector3) -> void:
	if cell_pos in streets.get_used_cells():
		streets.set_cell_item(cell_pos.x, 0, cell_pos.z, -1)

func get_cell_item(cell_pos: Vector3) -> int:
	return streets.get_cell_item(cell_pos.x, 0, cell_pos.z)

func set_cell_item(cell_pos: Vector3, cell_index: int, item_orientation: int = 0) -> void:
	streets.set_cell_item(cell_pos.x, 0, cell_pos.z, cell_index, item_orientation)

func get_cell_name(cell_item: int) -> String:
	return streets.mesh_library.get_item_name(cell_item)

func get_cell_index(item_name: String) -> int:
	return streets.mesh_library.find_item_by_name(item_name)

func _on_ia_alt_command_pressed(target: Node, position: Vector3) -> void:
	if not is_drawing:
		print_debug("Start tiling")
		is_drawing = true
		last_cell_pos.y = -1
	else:
		print_debug("End tiling")
		is_drawing = false
		draw_path = []
		emit_signal("tiles_changed")

func _on_ia_alt_command_released(target: Node, position: Vector3) -> void:
	if aborted:
		print_debug("End tiling (aborted)")
		aborted = false
		return

func _on_ia_main_command_released(target: Node, position: Vector3) -> void:
	print_debug("Abort tiling")
	for cell_pos in draw_path:
		set_cell_item(cell_pos, -1)

	is_drawing = false
	draw_path = []
	aborted = true
	emit_signal("tiles_changed")

func map_3_to_2(vec3: Vector3) -> Vector2:
	return Vector2(vec3.x, vec3.z)
