extends Spatial

class DistanceSorter:
    static func sort(a, b):
        if a["distance"] < b["distance"]:
            return true
        return false

var all_points = {}
var all_sea_points = {}
var all_land_points = {}

var as_node_sea: AStar = null
var as_node_land: AStar = null

onready var grid_map = $GridMap

var ray_plane := MeshInstance.new() as MeshInstance

func get_sea_path(start: Vector3, end: Vector3):
	return _get_gm_path(start, end, "sea")
	
func get_land_path(start: Vector3, end: Vector3):
	return _get_gm_path(start, end, "land")
	
func place_object(position: Vector3, object: Spatial, temp: bool) -> void:
	var point_index = v3_to_index(grid_map.world_to_map(position))
	var domain = "land" # should be in the objects data
	var domain_points = {}
	if domain == "land":
		domain_points = all_land_points
	if point_index in domain_points:
		var point_index_v3 = as_node_land.get_point_position(point_index)
		object.global_transform.origin = point_index_v3
		if not temp:
			as_node_land.remove_point(point_index)
	
	
func get_point_index_at_position(position: Vector3):
	var point_index = v3_to_index(grid_map.world_to_map(position))
	if point_index in all_points:
		# current_position is already on land so it returns null
		return point_index
		
func is_point_index_on_land(point_index: int) -> bool:
	if point_index in all_points:
		# current_position is already on land so it returns null
		return true
	else:
		return false
	
# get closest land point (usually from sea)
func get_closest_land_point(current_position: Vector3):
	var from_position = v3_to_index(grid_map.world_to_map(current_position))
	var start_id = 0
	var index = 0
	var distances = []
	if from_position in all_land_points:
		# current_position is already on land so it returns null
		return null
	else:
		var closest_point = as_node_land.get_closest_point(current_position)
		var closest_point_v3 = as_node_land.get_point_position(closest_point)
		var distance = sqrt(pow((closest_point_v3.x - current_position.x), 2) + pow((closest_point_v3.y - current_position.y), 2))
	
		return({"cell_index": closest_point, "position": closest_point_v3, "distance": distance})

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
	
	as_node_sea = AStar.new()
	as_node_land = AStar.new()
	# TODO: Make use of Vector3i in Godot 4.0.
	var cells = grid_map.get_used_cells()
	for cell in cells:
		if _get_cell_item_name(cell) in ["deep", "shallow_curve_in"]:
			var index = as_node_sea.get_available_point_id()
			as_node_sea.add_point(index, grid_map.map_to_world(cell.x, cell.y, cell.z))
			all_sea_points[v3_to_index(cell)] = index
			all_points[v3_to_index(cell)] = index
		elif not _get_cell_item_name(cell) in ["deep", "shallow_curve_in"]:
			var index = as_node_land.get_available_point_id()
			as_node_land.add_point(index, grid_map.map_to_world(cell.x, cell.y, cell.z))
			all_land_points[v3_to_index(cell)] = index
			all_points[v3_to_index(cell)] = index
	
	for cell in cells:
		if _get_cell_item_name(cell) in ["deep", "shallow_curve_in"]:
			for x in [-1, 0, 1]:
				for y in [-1, 0, 1]:
					for z in [-1, 0, 1]:
						var v3 = Vector3(x, y, z)
						
						if v3 == Vector3():
							continue
						
						if v3_to_index(v3 + cell) in all_sea_points:
							var ind1 = all_sea_points[v3_to_index(cell)]
							var ind2 = all_sea_points[v3_to_index(cell + v3)]
							if !as_node_sea.are_points_connected(ind1, ind2):
								as_node_sea.connect_points(ind1, ind2, true)
		elif not _get_cell_item_name(cell) in ["deep", "shallow_curve_in"]:
			for x in [-1, 0, 1]:
				for y in [-1, 0, 1]:
					for z in [-1, 0, 1]:
						var v3 = Vector3(x, y, z)
						
						if v3 == Vector3():
							continue
						
						if v3_to_index(v3 + cell) in all_land_points:
							var ind1 = all_land_points[v3_to_index(cell)]
							var ind2 = all_land_points[v3_to_index(cell + v3)]
							if !as_node_land.are_points_connected(ind1, ind2):
								as_node_land.connect_points(ind1, ind2, true)

func _get_cell_item_name(cell: Vector3) -> String:
	var cell_item_index = grid_map.get_cell_item(cell.x, cell.y, cell.z)
	var cell_item_name = grid_map.mesh_library.get_item_name(cell_item_index)
	return cell_item_name

func v3_to_index(v3: Vector3) -> String:
	# TODO: Make use of Vector3i in Godot 4.0.
	v3 = v3.round()
	return str(int(v3.x)) + "," + str(int(v3.y)) + "," + str(int(v3.z))
	
func index_to_v3(index: String) -> Vector3:
	# TODO: Make use of Vector3i in Godot 4.0.
	var v3 = Vector3();
	v3.x = float(index.split(",")[0])
	v3.y = float(index.split(",")[1])
	v3.z = float(index.split(",")[2])
	return v3
	


func _get_gm_path(start: Vector3, end: Vector3, domain: String) -> PoolVector3Array:
	#print_debug(start, end)
	var domain_points = {}
	var as_node = null
	if domain == "sea":
		as_node = as_node_sea
		domain_points = all_sea_points
	elif domain == "land":
		as_node = as_node_land
		domain_points = all_land_points
	var gm_start = v3_to_index(grid_map.world_to_map(start))
	var gm_end = v3_to_index(grid_map.world_to_map(end))
	var start_id = 0
	var end_id = 0
	if gm_start in domain_points:
		start_id = domain_points[gm_start]
	else:
		start_id = as_node.get_closest_point(start)
	if gm_end in domain_points:
		end_id = domain_points[gm_end]
	else:
		end_id = as_node.get_closest_point(end)
	var path = as_node.get_point_path(start_id, end_id)
	return path
