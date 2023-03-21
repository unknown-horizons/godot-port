@tool
extends TileMap3D

# map_size = 1
# xx
# xx
#
# map_size = 2
# xxxx
# xxxx
# xxxx
# xxxx

const TILES_PER_SIZE = 4
const TILES_PER_AXIS = TILES_PER_SIZE / 2

const DEFAULT_LAND = [3, "straight", 45]
const SAND = [6, "straight", 45]
const SHALLOW_WATER = [1, "straight", 45]
const WATER = [0, "straight", 45]

# sand to shallow water tiles
const COAST_SOUTH = [5, "straight", 45]
const COAST_EAST = [5, "straight", 135]
const COAST_NORTH = [5, "straight", 225]
const COAST_WEST = [5, "straight", 315]
const COAST_SOUTHWEST3 = [5, "curve_in", 135]
const COAST_NORTHWEST3 = [5, "curve_in", 225]
const COAST_NORTHEAST3 = [5, "curve_in", 315]
const COAST_SOUTHEAST3 = [5, "curve_in", 45]
const COAST_NORTHEAST1 = [5, "curve_out", 225]
const COAST_SOUTHEAST1 = [5, "curve_out", 135]
const COAST_SOUTHWEST1 = [5, "curve_out", 45]
const COAST_NORTHWEST1 = [5, "curve_out", 315]

# grass to sand tiles
const SAND_SOUTH = [4, "straight", 45]
const SAND_EAST =  [4, "straight", 135]
const SAND_NORTH = [4, "straight", 225]
const SAND_WEST =  [4, "straight", 315]
const SAND_SOUTHWEST3 = [4, "curve_in", 135]
const SAND_NORTHWEST3 = [4, "curve_in", 225]
const SAND_NORTHEAST3 = [4, "curve_in", 315]
const SAND_SOUTHEAST3 = [4, "curve_in", 45]
const SAND_NORTHEAST1 = [4, "curve_out", 225]
const SAND_SOUTHEAST1 = [4, "curve_out", 135]
const SAND_SOUTHWEST1 = [4, "curve_out", 45]
const SAND_NORTHWEST1 = [4, "curve_out", 315]

# shallow water to deep water tiles
const DEEP_WATER_SOUTH = [2, "straight", 45]
const DEEP_WATER_EAST =  [2, "straight", 135]
const DEEP_WATER_NORTH = [2, "straight", 225]
const DEEP_WATER_WEST =  [2, "straight", 315]
const DEEP_WATER_SOUTHWEST3 = [2, "curve_in", 135]
const DEEP_WATER_NORTHWEST3 = [2, "curve_in", 225]
const DEEP_WATER_NORTHEAST3 = [2, "curve_in", 315]
const DEEP_WATER_SOUTHEAST3 = [2, "curve_in", 45]
const DEEP_WATER_NORTHEAST1 = [2, "curve_out", 225]
const DEEP_WATER_SOUTHEAST1 = [2, "curve_out", 135]
const DEEP_WATER_SOUTHWEST1 = [2, "curve_out", 45]
const DEEP_WATER_NORTHWEST1 = [2, "curve_out", 315]

#current_coords_set: {(0, 0)}
#current_coords_set: {(0, 1), (1, 0), (0, 0), (1, 1)}

const TILE_OFFSETS = [
	# Direct connections
	Vector2( 0, -1), # East
	Vector2(+1,  0), # North
	Vector2( 0, +1), # South
	Vector2(-1,  0), # West
	# Remote connections
	Vector2(+1, -1), # North West
	Vector2(+1, +1), # North East
	Vector2(-1, +1), # South East
	Vector2(-1, -1), # South West
]

var tile_map: PackedVector2Array

@export var btn_update_tiles := false
@export var btn_fill_terrain := false
@export var btn_unfill_terrain := false
@export var btn_clean_terrain := false

func _ready() -> void:
	#if get_parent().is_inside_tree(): await get_parent().ready; _on_ready()

	var map_size = get_parent().map_size as int
	_resize_tile_map(map_size)

	update_tiles()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if btn_update_tiles: update_tiles(); btn_update_tiles = false
		if btn_fill_terrain: fill_terrain(); btn_fill_terrain = false
		if btn_unfill_terrain: unfill_terrain(); btn_unfill_terrain = false
		if btn_clean_terrain: clean_terrain(); btn_clean_terrain = false
	else:
		set_process(false)

func update_tiles() -> void:
	#print("update_tiles()")
	#for tile in get_used_tiles():
		#print(tile)

	#for tile_neighbor in TILE_OFFSETS:
	#	print(tile_neighbor)
	pass

func fill_terrain() -> void:
	print("fill_terrain")
	for tile_pos in tile_map:
		#print("({0}, {1}) | map_to_world: {2}".format([x, y, map_to_local(Vector3i(x,0,y))]))
		# NOTEFORME: map_to_world: center of cell (e.g. 0, 0 -> 0.5, 0.5)
		set_tile(tile_pos, "deep")

func unfill_terrain() -> void:
	print("unfill_terrain")
	for tile_pos in tile_map:
		unset_tile(tile_pos)

func clean_terrain() -> void:
	print("clean_terrain")
	for tile in tile_map:
		tile_map.append(tile)

	#prints("tile_map:", tile_map)
	for tile in get_used_tiles():
	# var tile = Vector2(cell.x, cell.z)
	#	if not tile in tile_map:
	#		unset_tile(tile)
		if not tile in tile_map:
			unset_tile(tile)

func _resize_tile_map(map_size: int) -> void:
	tile_map = PackedVector2Array()
	for y in map_size * TILES_PER_AXIS:
		for x in map_size * TILES_PER_AXIS:
			tile_map.append(Vector2(x, y))

func _on_AStarMap_map_size_changed(new_map_size: int) -> void:
	var map_size = new_map_size

	_resize_tile_map(map_size)
