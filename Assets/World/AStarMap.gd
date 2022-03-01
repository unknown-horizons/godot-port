tool
extends Spatial

signal map_size_changed(new_map_size) # int

var all_points := {}
var as_node: AStar2D = null

export var map_size := 100 setget set_map_size
export(NodePath) onready var grid_map_path

onready var grid_map := get_node(grid_map_path) as TileMap3D
onready var static_body: StaticBody = $StaticBody as StaticBody
onready var collision_shape: CollisionShape = static_body.get_node("CollisionShape") as CollisionShape

##var ray_plane := MeshInstance.new() as MeshInstance

func _ready() -> void:
	##ray_plane.mesh = PlaneMesh.new()
	##ray_plane.visible = true

	##ray_plane.scale = Vector3.ONE * 128 # TODO: Adapt size dynamically to GridMap's outer bounds

	#ray_plane.create_convex_collision() # crashes for GLES2 in the export build

	#var static_body = StaticBody.new()
	#var collision_shape = CollisionShape.new()
	#collision_shape.shape = PlaneShape.new()

	##ray_plane.set("material/0", SpatialMaterial.new())
	##ray_plane.get("material/0").set("flags_no_depth_test", true)
	##ray_plane.get("material/0").set("albedo_color", Color("1863d3"))
	##add_child(ray_plane)

	as_node = AStar2D.new()
	# TODO: Make use of Vector2i in Godot 4.0.
	var tiles = grid_map.get_used_tiles()
	for tile in tiles:
		if _get_tile_item_name(tile) in ["deep", "shallow_curve_in"]:
			var index = as_node.get_available_point_id()
			as_node.add_point(index, grid_map.tilemap_to_world(tile))
			all_points[v2_to_index(tile)] = index

	for tile in tiles:
		if _get_tile_item_name(tile) in ["deep", "shallow_curve_in"]:
			for x in [-1, 0, 1]:
				for y in [-1, 0, 1]:
						var v2 = Vector2(x, y)

						if v2 == Vector2.ZERO:
							continue

						if v2_to_index(v2 + tile) in all_points:
							var ind1 = all_points[v2_to_index(tile)]
							var ind2 = all_points[v2_to_index(tile + v2)]
							if !as_node.are_points_connected(ind1, ind2):
								as_node.connect_points(ind1, ind2, true)

func _get_tile_item_name(tile: Vector2) -> String:
	var tile_item_index = grid_map.get_tile_item(tile)
	return grid_map.get_item_name(tile_item_index)

func v2_to_index(v2: Vector2) -> String:
	# TODO: Make use of Vector2i in Godot 4.0.
	v2 = v2.round()
	return str(int(v2.x)) + "," + str(int(v2.y))

func get_tilemap_path(start: Vector2, end: Vector2) -> PoolVector2Array:
	#print_debug(start, end)
	var gm_start := v2_to_index(grid_map.world_to_tilemap(start))
	var gm_end := v2_to_index(grid_map.world_to_tilemap(end))
	var start_id := 0
	var end_id := 0
	if gm_start in all_points:
		start_id = all_points[gm_start]
	else:
		start_id = as_node.get_closest_point(start)
	if gm_end in all_points:
		end_id = all_points[gm_end]
	else:
		end_id = as_node.get_closest_point(end)
	return as_node.get_point_path(start_id, end_id)

func set_map_size(new_map_size: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	map_size = new_map_size if new_map_size > 0 else 0

	static_body.translation = Vector3(map_size, 0, map_size)
	collision_shape.shape.extents = Vector3(map_size, 0, map_size)

	emit_signal("map_size_changed", map_size)

func _on_ready() -> void:
	if not static_body: static_body = $StaticBody as StaticBody
	if not collision_shape: collision_shape = static_body.get_node("CollisionShape") as CollisionShape
