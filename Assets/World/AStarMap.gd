extends Spatial

var all_points = {}
var as_node: AStar = null

onready var grid_map = $GridMap

var ray_plane := MeshInstance.new() as MeshInstance

func _ready() -> void:
	ray_plane.mesh = PlaneMesh.new()
	ray_plane.visible = false

	ray_plane.scale = Vector3.ONE * 128 # TODO: Adapt size dynamically to GridMap's outer bounds

	#ray_plane.create_convex_collision() # crashes for GLES2 in the export build

	#var static_body = StaticBody.new()
	#var collision_shape = CollisionShape.new()
	#collision_shape.shape = PlaneShape.new()

	ray_plane.set("material/0", SpatialMaterial.new())
	ray_plane.get("material/0").set("flags_no_depth_test", true)
	ray_plane.get("material/0").set("albedo_color", Color("1863d3"))
	add_child(ray_plane)

	as_node = AStar.new()
	# TODO: Make use of Vector3i in Godot 4.0.
	var cells = grid_map.get_used_cells()
	for cell in cells:
		if _get_cell_item_name(cell) in ["deep", "shallow_curve_in"]:
			var index = as_node.get_available_point_id()
			as_node.add_point(index, grid_map.map_to_world(cell.x, cell.y, cell.z))
			all_points[v3_to_index(cell)] = index

	for cell in cells:
		if _get_cell_item_name(cell) in ["deep", "shallow_curve_in"]:
			for x in [-1, 0, 1]:
				for y in [-1, 0, 1]:
					for z in [-1, 0, 1]:
						var v3 = Vector3(x, y, z)

						if v3 == Vector3():
							continue

						if v3_to_index(v3 + cell) in all_points:
							var ind1 = all_points[v3_to_index(cell)]
							var ind2 = all_points[v3_to_index(cell + v3)]
							if !as_node.are_points_connected(ind1, ind2):
								as_node.connect_points(ind1, ind2, true)

func _get_cell_item_name(cell: Vector3) -> String:
	var cell_item_index = grid_map.get_cell_item(cell.x, cell.y, cell.z)
	var cell_item_name = grid_map.mesh_library.get_item_name(cell_item_index)
	return cell_item_name

func v3_to_index(v3: Vector3) -> String:
	# TODO: Make use of Vector3i in Godot 4.0.
	v3 = v3.round()
	return str(int(v3.x)) + "," + str(int(v3.y)) + "," + str(int(v3.z))

func get_gm_path(start: Vector3, end: Vector3) -> PoolVector3Array:
	#print_debug(start, end)
	var gm_start = v3_to_index(grid_map.world_to_map(start))
	var gm_end = v3_to_index(grid_map.world_to_map(end))
	var start_id = 0
	var end_id = 0
	if gm_start in all_points:
		start_id = all_points[gm_start]
	else:
		start_id = as_node.get_closest_point(start)
	if gm_end in all_points:
		end_id = all_points[gm_end]
	else:
		end_id = as_node.get_closest_point(end)
	return as_node.get_point_path(start_id, end_id)
