extends InteractionContext
class_name TileContext

signal tiles_changed(scaffold_tiles: Array, can_built: bool)

const PHANTOM_TILE_TEXTURE = preload("res://Assets/World/Buildings/Streets/Sprites/trail_single.png")

@onready var streets: TileMap3D = get_node("/root/World/AStarMap/Streets") as TileMap3D

var m_pos: Vector2

var phantom_tile: Sprite3D

var last_tile_pos: Vector2

var is_drawing := false
var draw_path := []
var aborted := false

func _ready() -> void:
	connect("tiles_changed", Callable(streets, "update_tiles"))

	set_process(false)

func show_phantom_tile(tile_pos: Vector2) -> void:
	phantom_tile.position = streets.map_to_local(Vector3i(tile_pos.x,0,tile_pos.y))

func handle_tiles(raycast_position: Vector2) -> void:
	var tile_pos = streets.world_to_tilemap(raycast_position)
	#var tile_item = streets.get_tile_item(tile_pos)
	#var mesh_library = streets.mesh_library
	#var item_name = mesh_library.get_item_name(tile_item)

	prints("tile pos:", tile_pos)
	#prints("tile item:", tile_item)
	#prints("mesh_library:", mesh_library.resource_name)
	#prints("item_mesh:", item_name)

	#prints("orientation:", streets.get_tile_item_orientation(tile_pos))

func _on_enter() -> void:
	print("InteractionContext %s entered" % _context_name)
	var material := StandardMaterial3D.new()
	material.flags_transparent = true
	material.flags_no_depth_test = true
	material.params_billboard_mode = StandardMaterial3D.BILLBOARD_ENABLED
	material.albedo_texture = PHANTOM_TILE_TEXTURE

	phantom_tile = Sprite3D.new()
	phantom_tile.texture = PHANTOM_TILE_TEXTURE
	phantom_tile.pixel_size = 0.02
	phantom_tile.material_override = material
	add_child(phantom_tile)
	Input.set_custom_mouse_cursor(Cursor.CURSOR_TEAR, Input.CURSOR_ARROW)

	set_process(true)

func _on_exit() -> void:
	print("InteractionContext %s exited" % _context_name)
	phantom_tile.queue_free()
	Input.set_custom_mouse_cursor(Cursor.CURSOR_DEFAULT, Input.CURSOR_ARROW)

	set_process(false)

func _process(_delta: float) -> void:
	m_pos = _player_camera.get_viewport().get_mouse_position()

	var tile_pos = streets.get_tile_at_mouse_position()

	if tile_pos == last_tile_pos:
		return

	show_phantom_tile(tile_pos)

	if is_drawing:
		#print_debug("Check if tiling is executed on valid terrain")
		if draw_path.size() >= 4 and tile_pos == draw_path[-4] or \
		not tile_pos in streets.get_used_tiles(): # free tile?
			prints(tile_pos)
			draw_path.append(tile_pos)
			streets.set_tile_item(tile_pos, 0)
			emit_signal("tiles_changed", draw_path)
		else: # occupied cell
			if draw_path.size() > 1:
				if tile_pos == draw_path[-2]:
					#draw_path.remove_at(draw_path.size() - 1)
					var cell_to_be_removed = draw_path.pop_back()
					if not cell_to_be_removed in draw_path:
						streets.set_tile_item(cell_to_be_removed, -1)
					emit_signal("tiles_changed", draw_path)

	#prints("tile_pos:", tile_pos, "last_tile_pos:", last_tile_pos)
	last_tile_pos = tile_pos
	#prints(" === draw_path:", draw_path)

func _on_mouse_motion(target: Node, position: Vector2) -> void:
	pass

func _on_ia_alt_command_pressed(target: Node, position: Vector2) -> void:
	if not is_drawing:
		print_debug("Start tiling")
		is_drawing = true
		last_tile_pos.y = -1
	else:
		print_debug("End tiling")
		is_drawing = false
		draw_path = []
		emit_signal("tiles_changed")

func _on_ia_alt_command_released(target: Node, position: Vector2) -> void:
	if aborted:
		print_debug("End tiling (aborted)")
		aborted = false
		return

#	if not is_drawing:
#		abort_context()

func _on_ia_main_command_pressed(target: Node, position: Vector2) -> void:
	pass

func _on_ia_main_command_released(target: Node, position: Vector2) -> void:
	print_debug("Abort tiling")
	for cell_pos in draw_path:
		streets.unset_tile(cell_pos)

	if is_drawing:
		is_drawing = false
	else:
		abort_context()

	draw_path = []
	aborted = true
	emit_signal("tiles_changed")
