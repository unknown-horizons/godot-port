extends TileMapLayer

class_name BuiltTileMap

const is_tree: String = "is_tree"
const is_road: String = "is_road"

var building_name_to_cell_coords: Dictionary[String, Array] = {} # Dictionary[String, Array[Vector2i]] = {}. Nested types are not supported in Godot 4.5
var building_position_to_building: Dictionary[Vector2i, Building2D] = {}
var trees_getting_choped: Dictionary = {}

## emited when new buildings were built, usually one building at a time
signal buildings_built(building: Building2D, cells: Array[Vector2i])

func register_initial_scenes():
	for cell in self.get_children():
		var building: Building2D = cell as Building2D
		self.register_building(building, false) # keep the cell uncleared to prevent scene deletion

func _ready() -> void:
	register_initial_scenes()

## test tiers
#	 for pos in self.get_used_cells():
#		 var source_id = self.get_cell_source_id(pos)
#		 if source_id == 4:
#			 print("Broken tile at", pos)
#	 while true:
#		 await self.get_tree().create_timer(5).timeout
#		 var world_enum_tier: WorldTiers.TierEnum = WorldTiers.TierEnum.get(GameStats.game_stats_resource.world_tier, WorldTiers.TierEnum.SAILORS)
#		 world_enum_tier = (world_enum_tier + 3) % WorldTiers.TierEnum.MAX - 2
#		 GameStats.game_stats_resource.world_tier = WorldTiers.TierEnum.find_key(world_enum_tier)

func is_movable_on(cell: Vector2i) -> bool:
	var tile_data: TileData = self.get_cell_tile_data(cell)
	if tile_data != null:
		var terrain_name: String = self.tile_set.get_terrain_name(tile_data.terrain_set, tile_data.terrain)
		var is_road = terrain_name == "DirtRoad"
		return is_road
	return false

func get_trees() -> Array[Vector2i]:
	var trees: Array[Vector2i] = []
	for cell in self.get_used_cells():
		var cell_data = self.get_cell_tile_data(cell)
		if cell_data != null and cell_data.get_custom_data(is_tree):
			trees.append(cell)
	return trees

func build(building_instance: Building2D) -> void:
	self.register_building(building_instance, true)

func register_building(building: Building2D, clear_origin: bool) -> void:
	print("BuiltTileMap.register_building(%s[%s], %s)" % [building.id, building, clear_origin])
	# register building to building poses
	var building_all_cell_coords = building_name_to_cell_coords.get(building.id, [])
	var building_tile_coords = self.local_to_map(building.position)
	var new_building_cells: Array[Vector2i] = []

	var road_building_context = %GameContextManager.get_node("BuildingRoadContext")
	var road_pathfinding = %PathfindingManager.road_pathfinding

	var buildings_built_on: Array[Building2D] = []
	var cells: Array[Array] = building.get_oriented_cells()
	for row in cells:
		for dv: Vector2i in row:
			var building_cell_tile_coords = building_tile_coords + dv # build up and left
			# get the buildings this building is getting built on(if any)
			var building_on_cell: Building2D = self.building_position_to_building.get(building_cell_tile_coords, null)
			if building_on_cell != null:
					buildings_built_on.append(building_on_cell)

			new_building_cells.append(building_cell_tile_coords)
			self.building_position_to_building[building_cell_tile_coords] = building
			building_all_cell_coords.append(building_cell_tile_coords)
			road_pathfinding.set_point_solid(building_cell_tile_coords, true)
			road_building_context.road_building_pathfindng.set_point_solid(building_cell_tile_coords, true)

	for cell in new_building_cells:
		if cell != building_tile_coords or clear_origin: # erase all other cells which the building covers
			self.set_cell(cell, -1)

	# add all buildings that were built on top of, to the building built
	for building_built_on: Building2D in buildings_built_on:
		building_built_on.position = Vector2i.ZERO
		building_built_on.visible = false
		building_built_on.reparent(building, true)

	building.paused = false

	self.invalidate_buildings_caches(new_building_cells)
	# handle notifications
	buildings_built.emit(building, new_building_cells)

func invalidate_buildings_caches(cells: Array[Vector2i]) -> void:
	for node in self.get_children():
		var building: Building2D = node as Building2D
		if building != null:
			building.invalidate_cache(cells)

func demolish(cell: Vector2i) -> void:
	print("BuiltTileMap.demolish(%s)" % cell)
	# demolish building if any
	var affected_cells: Array[Vector2i] = []
	var building: Building2D = self.building_position_to_building.get(cell, null)
	if building != null:
		var road_building_pathfindng: Pathfinder = %GameContextManager.get_node("BuildingRoadContext").road_building_pathfindng
		var building_oriented_cells := building.get_oriented_cells()
		var building_starting_cell: Vector2i = self.local_to_map(building.position)
		for row: Array[Vector2i] in building_oriented_cells:
			affected_cells.append_array(row)
			for dv: Vector2i in row:
				var building_cell: Vector2i = building_starting_cell + dv
				self.building_position_to_building.erase(building_cell)
				road_building_pathfindng.set_point_solid(building_cell, false)

		# put back all other buildings that were built on top of(deposits)
		var buildings_built_on := building.get_all_nodes_of_type(Building2D)
		for building_built_on: Building2D in buildings_built_on:
			building_built_on.reparent(self, true)
			building_built_on.visible = true
			self.register_building(building_built_on, true)
		building.paused = true # stop all action

	var road_pathfinding: Pathfinder = %PathfindingManager.road_pathfinding
	affected_cells.append(cell)
	self.set_cell(cell, -1) # delete cell
	road_pathfinding.set_point_solid(cell, true)
	# update road
	for neighbor in self.get_surrounding_cells(cell):
		var tile_data: TileData = self.get_cell_tile_data(neighbor)
		if tile_data != null:
			var terrain_set: int = tile_data.terrain_set
			var terrain: int = tile_data.terrain
			if terrain == -1:
				continue
			if self.tile_set.get_terrain_name(terrain_set, terrain) == "DirtRoad":
				self.set_cell(neighbor, -1)
				self.set_cells_terrain_connect([neighbor], terrain_set, terrain, false)

	# invalidate buildings caches before resuming the building to be deleted
	# this avoid the race condition when the other async loops (get_best_job) are resumed, but their caches still contain this building
	self.invalidate_buildings_caches(affected_cells)

	if building != null:
		# other async loops (get_best_job) are resumed on `building.cancel_sleep`. That's ok, since current building are no longer registered in built_tilemap
		building.cancel_sleep.emit() # notify the building to stop(timers)
		building.queue_free()

# debug layer:
@onready var tooltip_label: Label = self.get_node("/root/Main/DebugCanvasLayer/Control/BuiltTileMapLayerInfo") if not Engine.is_editor_hint() else null

var last_cell_coords: Vector2i = Vector2i(-999, -999)	# Init to invalid coords
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# var viewport = self.get_viewport()
		# var mouse_pos = viewport.get_mouse_position()
		# var local_mouse_pos1 = self.to_local(mouse_pos)
		# var local_mouse_pos2 = event.global_position
		# var gp1 = self.get_global_mouse_position()
		# var gp2 = event.global_position
		var local_mouse_pos = self.to_local(self.get_global_mouse_position())
		var cell_coords = self.local_to_map(local_mouse_pos)

		if cell_coords != last_cell_coords: # Avoid redundant updates
			last_cell_coords = cell_coords
			_update_tooltip(cell_coords)

func _update_tooltip(cell_coords: Vector2i):
	var atlas_coords = self.get_cell_atlas_coords(cell_coords)
	var cell_alternative_tile = self.get_cell_alternative_tile(cell_coords)
	# var tile_data = self.get_cell_tile_data(cell_coords)

	var building = self.building_position_to_building.get(cell_coords, null)
	self.tooltip_label.text = "Tile: %s\nAtlas: %s\ncell_alternative_tile: %s\nBuilding: %s" % [cell_coords, atlas_coords, cell_alternative_tile, building]

## returns the cell bitmask for the buildings on it(any_building, mountain, stone_deposit, clay_deposit) if no building on it, returns 0
func get_cell_building_bitmask(cell: Vector2i) -> int:
	# find the cell bitmask for buildings on it
	var cell_bitmask: int = 0
	var building_on_tile: Building2D = self.building_position_to_building.get(cell) # Is the cell a building?
	if building_on_tile != null:
		cell_bitmask = 1 << 7 # any building
		var building_on_tile_string_name := BuildingConfig.id_to_string_name(building_on_tile.id)
		cell_bitmask |= int(building_on_tile_string_name == BuildingConfig.Buildings.CLAY_DEPOSIT)	<< 4
		cell_bitmask |= int(building_on_tile_string_name == BuildingConfig.Buildings.STONE_DEPOSIT) << 5
		cell_bitmask |= int(building_on_tile_string_name == BuildingConfig.Buildings.MOUNTAIN)			<< 6

	return cell_bitmask

func get_buildings_in_radius(rect: Rect2i, radius: int) -> Array[Building2D]:
	var buildings_in_radius: Dictionary[Building2D, bool] = {}

	var affected_rect := rect.grow(radius)
	for y in range(affected_rect.position.y, affected_rect.end.y):
		for x in range(affected_rect.position.x, affected_rect.end.x):
			var cell := Vector2i(x, y)
			if Utils.distance_to_rect_L1(cell, affected_rect) > radius:
				continue
			var building: Building2D = self.building_position_to_building.get(cell, null)
			if building != null:
				buildings_in_radius[building] = true

	return buildings_in_radius.keys()

func get_building_to_building_path(src_building: Building2D, dst_building: Building2D, pathfinding: Pathfinder) -> NavPath:
	var path := self.get_rect_to_rect_path(src_building.oriented_rect, dst_building.oriented_rect, pathfinding)
	print("	Path from %s to %s: %s" % [src_building.__repr__, dst_building.__repr__, path])
	return path

func get_rect_to_rect_path(src_rect: Rect2i, dst_rect: Rect2i, pathfinding: Pathfinder) -> NavPath:
	var was_impassable_src := pathfinding.is_point_solid(src_rect.position) # We use only first point to remember if it was solid
	if was_impassable_src:
		pathfinding.fill_solid_region(src_rect, false) # the unit should be able to walk on src building

	var was_impassable_dst := pathfinding.is_point_solid(dst_rect.position) # We use only first point to remember if it was solid
	if was_impassable_dst:
		pathfinding.fill_solid_region(dst_rect, false) # the unit should be able to walk on partner dst_building

	# var merged = src_rect.merge(dst_rect)
	# var pt_data = pathfinding.get_point_data_in_region(merged)
	# var cnt_x = 0
	# var s := ""
	# print(merged)
	# for pt in pt_data:
	#	 s += "x" if pt["solid"] else "o"
	#	 cnt_x += 1
	#	 if cnt_x % merged.size.x == 0:
	#		 print(s)
	#		 s = ""
	var shortest_path: Array[Vector2i] = []
	for src_y in range(src_rect.position.y, src_rect.end.y):
		for src_x in range(src_rect.position.x, src_rect.end.x):
			var src_cell = Vector2i(src_x, src_y)
			for dst_y in range(dst_rect.position.y, dst_rect.end.y):
				for dst_x in range(dst_rect.position.x, dst_rect.end.x):
					var dst_cell = Vector2i(dst_x, dst_y)
					var cur_path = pathfinding.get_id_path(src_cell, dst_cell)
					if cur_path.size() > 0:
						if shortest_path.size() == 0 or cur_path.size() < shortest_path.size():
							shortest_path = cur_path
	var res_path: NavPath = NavPath.new(shortest_path) if shortest_path.size() > 0 else null

	if was_impassable_dst:
		pathfinding.fill_solid_region(dst_rect, true) # make partner dst_building non-passible

	if was_impassable_src:
		pathfinding.fill_solid_region(src_rect, true) # make it non-passible

	return res_path

func get_cell_position_to_building_path(cell_position: Vector2i, dst_building: Building2D, pathfinding: Pathfinder) -> NavPath:
	var path := self.get_rect_to_rect_path(Rect2i(cell_position, Vector2i.ONE), dst_building.oriented_rect, pathfinding)
	print("	Path from %s to %s: %s" % [cell_position, dst_building.__repr__, path])
	return path
