@tool
extends Node3D
class_name AStarMap

signal map_size_changed(new_map_size: int)

var all_points := {}
var as_node: AStar2D = null

@export var map_size := 100:
	set(new_map_size):
		if not is_inside_tree():
			await self.ready

		map_size = clampi(new_map_size, 0, 256)

		static_body.position = Utils.map_2i_to_3i(Vector2(map_size, map_size))
		collision_shape.shape.extents = Utils.map_2i_to_3i(Vector2(map_size, map_size))

		emit_signal("map_size_changed", map_size)

@export var tile_map: TileMap3D

@onready var static_body := $StaticBody3D as StaticBody3D
@onready var collision_shape := static_body.get_node("CollisionShape3D") as CollisionShape3D

func _ready() -> void:
	as_node = AStar2D.new()

	var tiles = tile_map.get_used_tiles()

	for tile in tiles:
		if _get_tile_item_name(tile) in ["deep", "shallow_curve_in"]:
			var index = as_node.get_available_point_id()
			as_node.add_point(index, tile_map.tile_map_to_local(tile))
			all_points[v2_to_index(tile)] = index

	for tile in tiles:
		if _get_tile_item_name(tile) in ["deep", "shallow_curve_in"]:
			for x in [-1, 0, 1]:
				for y in [-1, 0, 1]:
						var v2 = Vector2i(x, y)

						if v2 == Vector2i.ZERO:
							continue

						#prints("v2:", v2, "tile:", tile)
						if v2_to_index(v2 + tile) in all_points:
							var i1 = all_points[v2_to_index(tile)]
							var i2 = all_points[v2_to_index(tile + v2)]
							if !as_node.are_points_connected(i1, i2):
								as_node.connect_points(i1, i2, true)

func _get_tile_item_name(tile: Vector2i) -> String:
	var tile_item_index = tile_map.get_tile_item(tile)
	return tile_map.get_item_name(tile_item_index)

func v2_to_index(v2: Vector2i) -> String:
	#print("v2_to_index(", v2, ")")
	return str(v2.x) + "," + str(v2.y)

func get_tile_map_path(start: Vector2i, end: Vector2i) -> PackedVector2Array:
	#print_debug(start, end)
	var tile_map_start: Vector2i = tile_map.local_to_tile_map(start)
	var tile_map_end: Vector2i = tile_map.local_to_tile_map(end)
	var start_id := 0
	var end_id := 0
	if tile_map_start in all_points:
		start_id = all_points[tile_map_start]
	else:
		start_id = as_node.get_closest_point(start)
	if tile_map_end in all_points:
		end_id = all_points[tile_map_end]
	else:
		end_id = as_node.get_closest_point(end)
	return as_node.get_point_path(start_id, end_id)
