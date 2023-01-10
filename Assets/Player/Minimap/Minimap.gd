extends Control
class_name Minimap


var size : Vector2
var scale : Vector2
var terrain : GridMap
var terrain_tile_count : Vector2


func _ready():
	size = self.rect_size
	terrain = get_tree().current_scene.get_node("AStarMap/Terrain") as GridMap
	
	var tile_min := Vector2.ZERO
	var tile_max := Vector2.ZERO
	
	# get terrain tile count along each axis 
	for tile in terrain.get_used_cells():
		var tile_index = tile as Vector3
		
		if tile_index.x > tile_max.x:
			tile_max.x = tile_index.x
		elif tile_index.x < tile_min.x:
			tile_min.x = tile_index.x
			
		if tile_index.z > tile_max.y:
			tile_max.y = tile_index.z
		elif tile_index.z < tile_min.y:
			tile_min.y = tile_index.z
	
	# plus one at the end is required because
	# we need the count not the index
	terrain_tile_count = (tile_max - tile_min) + Vector2.ONE
	scale = size / terrain_tile_count
	
	# now draw each layer one by one
	for layer in get_children():
		(layer as MinimapLayer).draw_layer()


func world_to_minimap_position(world_position : Vector3) -> Vector2:
	var map_position := terrain.world_to_map(world_position)
	print(scale)
	return Vector2(map_position.x, map_position.z)
