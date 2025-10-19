@tool

extends BaseComponent

class_name Collector

class Job:
  var path_to_start: Array[Vector2i]
  var path_from_start_to_end: Array[Vector2i]
  var resource: StringName

  func _init(path_to_start: Array[Vector2i] = [], path_from_start_to_end: Array[Vector2i] = [], resource: StringName = ResourceConfig.Resources.NONE) -> void: #, building_from: Building2D, building_to: Building2D):
    self.path_to_start = path_to_start
    self.path_from_start_to_end = path_from_start_to_end
    self.resource = resource
  
  func _to_string() -> String:
    if self.path_to_start == [] or self.path_from_start_to_end == []:
      return "Resource: %s" % self.resource
    return "Resource: %s, From: %s, To: %s" % [self.resource, self.path_to_start[-1], self.path_from_start_to_end[-1]]

const CollectorTypes: Dictionary[StringName, StringName] = {
  BUILDING_COLLECTOR   = &"BUILDING_COLLECTOR",
  LUMBERJACK_COLLECTOR = &"LUMBERJACK_COLLECTOR",
}


@export var baseclass: String  # TODO: not used yet
@export var radius: int = 10
@export var velocity: float    # TODO: not used yet

@onready var built_tilemap: BuiltTileMap = self.get_node("/root/Main/BuiltTileMap") if not Engine.is_editor_hint() else null
@onready var parent_building: Building2D = self.get_parent() if not Engine.is_editor_hint() else null

# var building_from: Building2D
# var building_to: Building2D

# var resource: StringName = ResourceConfig.Resources.NONE
# var amount: int = 0

var load_or_unload_time: float = 2

var building_storage: SlotStorageComponent
var production_line_components: Array[ProductionLineComponent]

var storage: SizedStorageComponent
var move_by_cell: MoveByCellComponent
var action_set: BuildingActionSet


var collector_type: String = self.CollectorTypes.BUILDING_COLLECTOR:
  set(value):
    collector_type = value
    if self.move_by_cell:
      match self.collector_type:
        self.CollectorTypes.BUILDING_COLLECTOR:
          self.move_by_cell.allowed_movement = self.MoveByCellComponent.AllowedMovementTypes.MOVE_ON_ROAD
        self.CollectorTypes.LUMBERJACK_COLLECTOR:
          self.move_by_cell.allowed_movement = self.MoveByCellComponent.AllowedMovementTypes.MOVE_ON_LAND 

var collector_type_to_get_jobs_function: Dictionary[StringName, Callable] = {
  self.CollectorTypes.BUILDING_COLLECTOR: self.get_jobs_for_building_collector,
  self.CollectorTypes.LUMBERJACK_COLLECTOR: self.get_jobs_for_lumberjack_collector
}

var collector_type_to_load_function: Dictionary[StringName, Callable] = {
  self.CollectorTypes.BUILDING_COLLECTOR: self.load_resources_for_building_collector,
  self.CollectorTypes.LUMBERJACK_COLLECTOR: self.chop_tree
}



#region Editor: dynamic values for dropdown for `collector_type`
func _get_property_list() -> Array:
  var ret: Array[Dictionary] = [
    {
      "name": "Collector Type",
      "default": self.CollectorTypes.BUILDING_COLLECTOR,
      "type": TYPE_STRING,
      "hint": PROPERTY_HINT_ENUM,
      "hint_string": ",".join(self.CollectorTypes.keys()),
      "usage": PROPERTY_USAGE_DEFAULT,
    }]
  if self.collector_type == self.CollectorTypes.LUMBERJACK_COLLECTOR:
    ret.append({
      "name": "Load or Unload Time",
      "default": 2,
      "type": TYPE_FLOAT,
      # "hint": PROPERTY_HINT_FLOAT,
      "usage": PROPERTY_USAGE_DEFAULT
    }) # add unload time if lumberjack
  return ret

func _get(property_name):
  match property_name:
    "Collector Type":
      return self.collector_type
    "Load or Unload Time":
      return self.load_or_unload_time

func _set(property_name, val):
  match property_name:
    "Collector Type":
      self.collector_type = val
    "Load or Unload Time":
      self.load_or_unload_time = val
#endregion



# func set_pause(value: bool) -> void:
#   super(value)
#   collecting_loop()



func _ready() -> void:
  var components: Array[BaseComponent] = []
  for node: Node in self.get_children():
    var component := node as BaseComponent
    if component != null:
      components.append(component)
  
  for component in components:
    if component is SizedStorageComponent:
      self.storage = component
    if component is MoveByCellComponent:
      self.move_by_cell = component
    if component is BuildingActionSet:
      self.action_set = component
    component.set_components(components)

func set_components(new_components: Array[BaseComponent]) -> void:
  for component in new_components:
    if component is SlotStorageComponent:
      self.building_storage = component as SlotStorageComponent
    if component is ProductionLineComponent:
      self.production_line_components.append(component)
  if self.paused:
    await self.unpaused
  self.collecting_loop()



## returns the shortest path the unit can take from -> to
func get_cell_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
  if self.move_by_cell == null or self.move_by_cell.pathfinding == null:
    push_error("move_by_cell or move_by_cell.pathfinding is null")
    return []
  var path = self.move_by_cell.pathfinding.get_path_to_dest(from, to, true, true)
  if path == null:
    return []
  # make array typed
  var typed_path: Array[Vector2i] = []
  for point in path:
    typed_path.append(point as Vector2i)
  return typed_path

## Returns a list of (dx, dy) that are within the radius sorted by cell distance
func get_cells_in_radius(radius: int) -> Array[Vector2i]:
  var cells_in_radius: Array[Vector2i] = []
  for dx in range(-self.radius, self.radius + 1):
    for dy in range(-self.radius, self.radius + 1):
      if dx + dy <= self.radius:
        cells_in_radius.append(Vector2i(dx, dy))

  cells_in_radius.sort_custom(func(a, b): return abs(a).x + abs(a).y < abs(b).x + abs(b).y)
  return cells_in_radius

func get_path_to_closest_warehouse() -> Array[Vector2]:
  if built_tilemap == null: # if the built tilemap is null, then return null
    return []
  var path_to_warehouse: Array[Vector2] = []
  for building_cell in built_tilemap.building_name_to_cell_coords.get("Warehouse", []): # loop through the buildings
    var warehouse := self.built_tilemap.building_position_to_building.get(building_cell, null) as Warehouse2D
    if warehouse: # if the building is a warehouse,
      var path_to_current_warehouse = move_by_cell.pathfinding.get_path_to_dest(self.global_position, warehouse.global_position) # get the path to the warehouse.
      if path_to_current_warehouse == null:
        continue
      if (path_to_warehouse == [] or len(path_to_current_warehouse) < len(path_to_warehouse)) and path_to_current_warehouse != null: # if the warehouse is closer than the last closest warehouse,
        path_to_warehouse = []
        for cell in path_to_current_warehouse:
          path_to_warehouse.append(cell as Vector2)
  return path_to_warehouse

## Returns the best possible job at the moment
func get_best_job() -> Job:
  if self.building_storage == null:
    return null
  var collector_map_position: Vector2i = self.built_tilemap.local_to_map(self.global_position)
  var parent_building_map_position: Vector2i = self.built_tilemap.local_to_map(self.parent_building.global_position)
  var best_job: Job = null
  var best_job_score: float = -1
  var jobs: Array[Job] = self.collector_type_to_get_jobs_function.get(self.collector_type, func(): return []).call()

  for job in jobs:
    if job == null:
      continue
    var score: float = 1 - (len(job.path_to_start) + len(job.path_from_start_to_end)) / float(self.radius) / 2 # 0-1
    if score >= best_job_score:
      best_job = job
      best_job_score = score

  if best_job == null and collector_map_position != parent_building_map_position: # if there is no job, go home if not home
    best_job = Job.new([collector_map_position], self.get_cell_path(collector_map_position, parent_building_map_position), ResourceConfig.Resources.NONE)
  return best_job


## the loop for the collecting logic, called at start
func collecting_loop() -> void:
  while true:
    if self.paused:
      await self.unpaused
    var job: Job = await self.wait_for_job()
    if self.collector_type == self.CollectorTypes.LUMBERJACK_COLLECTOR:
      self.built_tilemap.trees_getting_choped[job.path_from_start_to_end[0]] = null
    await self.move_by_cell.move(job.path_to_start)
    await self.load_resources(job)
    await self.move_by_cell.move(job.path_from_start_to_end)
    await self.unload_resources(job)

func wait_for_job() -> Job:
  self.visible = false
  var best_job: Job = self.get_best_job()
  while best_job == null:
    await GameStats.game_stats_resource.resources_changed
    if self.paused:
      await self.unpaused
    best_job = self.get_best_job()
  return best_job

func load_resources(job: Job) -> void:
  await self.collector_type_to_load_function.get(self.collector_type, func(_job): return).call(job) # call correct load function

## Unloads resources, one for all types right now
func unload_resources(job: Job) -> void:
  # await self.collector_type_to_unload_function.get(self.collector_type, func(): return).call(self, job) # call correct unload function
  self.visible = false
  if self.storage == null or self.built_tilemap == null:
    push_error("Mising nodes in Collector.gd, unload_resources")
    return
  var building: Building2D = self.built_tilemap.building_position_to_building.get(job.path_from_start_to_end[-1])
  if building == null:
    return
  await building.unload_resource(job.resource, self.storage.get_storage_item_amount(job.resource))
  self.storage.set_storage_item_amount(job.resource, 0)


## returns all possible jobs for a building collector
func get_jobs_for_building_collector() -> Array[Job]:
  if self.collector_type != self.CollectorTypes.BUILDING_COLLECTOR:
    push_error("Wrong function called for this collector. Collector: %s, get_jobs_for_building_collector" % self.collector_type)
    return []
  if self.building_storage == null or self.built_tilemap == null or self.parent_building == null:
    push_error("Mising nodes in Collector.gd, get_jobs_for_building_collector")
    return []

  var collector_map_position: Vector2i = self.built_tilemap.local_to_map(self.global_position)
  var parent_building_map_position: Vector2i = self.built_tilemap.local_to_map(self.parent_building.global_position)
  var cells_in_radius: Array[Vector2i] = self.get_cells_in_radius(self.radius)
  var jobs: Array[Job] = []
  # print("Building: %s" % [self.get_parent().name])
  # create jobs for each resource
  for delta in cells_in_radius:
    var cell := parent_building_map_position + delta
    #print("  Cell: %s" % [cell])
    #if cell == Vector2i(20, 27):
      #print("Hey")
    var other_building: Building2D = self.built_tilemap.building_position_to_building.get(cell)
    if other_building == null or other_building == self.parent_building:
      continue
    # print("  Other building: %s" % [other_building.name])
    # ckeck for any jobs possible with the other_building
    for resource in self.building_storage.storage.keys():
      # print("    Resource: %s" % [resource])
      # get if consumed and/or produced
      var consumed: bool = false
      var produced: bool = false
      for production_line in self.production_line_components:
        consumed = production_line.consumes.has(resource) or consumed
        produced = production_line.produces.has(resource) or produced

      if consumed and produced: # do nothing
        continue
      if consumed: # the resource is consumed by the this building, create job to bring it in
        if other_building.is_resource_available(resource) == false:
          continue
        var path_to_start: Array[Vector2i] = self.get_cell_path(collector_map_position, cell) # to cell
        var path_from_start_to_end: Array[Vector2i] = self.get_cell_path(cell, parent_building_map_position) # from cell to other_building
        var new_job: Job = Job.new(path_to_start, path_from_start_to_end, resource)
        jobs.append(new_job)
      if produced: # the resource is produced by the this building, create job to take it out
        if self.building_storage.get_storage_item_amount(resource) <= 0:
          continue
        if not other_building.id in ["BUILDINGS." + BuildingConfig.Buildings.WAREHOUSE, "BUILDINGS." + BuildingConfig.Buildings.STORAGE]:
          continue
        var path_to_start: Array[Vector2i] = self.get_cell_path(collector_map_position, parent_building_map_position) # to this building
        var path_from_home_to_job: Array[Vector2i] = self.get_cell_path(parent_building_map_position, cell) # from cell to other_building
        var new_job: Job = Job.new(path_to_start, path_from_home_to_job, resource)
        jobs.append(new_job)
  return jobs

## loads resources for a building collector
func load_resources_for_building_collector(job: Job) -> void:
  self.visible = false
  var building: Building2D = self.built_tilemap.building_position_to_building.get(job.path_from_start_to_end[0])
  if building == null:
    return
  var needed_resource_amount: int = 0
  if building == self.parent_building:
    needed_resource_amount = self.building_storage.get_storage_item_amount(job.resource)
  else:
    needed_resource_amount = self.building_storage.max_capacity.get(job.resource, 0) - self.building_storage.get_storage_item_amount(job.resource)
  var resource_amount: int = await building.load_resource(job.resource, needed_resource_amount)
  if self.paused:
    await self.unpaused
  self.storage.set_storage_item_amount(job.resource, resource_amount)



## returns all possible jobs for a lumberjack collector
func get_jobs_for_lumberjack_collector() -> Array[Job]:
  if self.collector_type != self.CollectorTypes.LUMBERJACK_COLLECTOR:
    push_error("Wrong function called for this collector. Collector: %s, get_jobs_for_lumberjack_collector" % self.collector_type)
    return []
  if self.built_tilemap == null or self.parent_building == null or self.building_storage == null:
    push_error("Mising nodes in get_jobs_for_lumberjack_collector, Collector.gd")
  if self.building_storage.storage.has(ResourceConfig.Resources.TREES) == false:
    push_error("Building can not store wood but has a lumberjack collector")
    return []
  if self.building_storage.get_storage_item_amount(ResourceConfig.Resources.TREES) >= self.building_storage.max_capacity.get(ResourceConfig.Resources.TREES):
    return []
  var collector_map_position: Vector2i = self.built_tilemap.local_to_map(self.global_position)
  var parent_building_map_position: Vector2i = self.built_tilemap.local_to_map(self.parent_building.global_position)
  var cells_in_radius: Array[Vector2i] = self.get_cells_in_radius(self.radius)
  var jobs: Array[Job] = []
  # find all trees and create a job for each
  for delta in cells_in_radius:
    var cell := parent_building_map_position + delta
    var cell_data: TileData = self.built_tilemap.get_cell_tile_data(cell)
    if cell_data == null:
      continue
    if cell_data.get_custom_data(self.built_tilemap.is_tree) == true:
      if cell in self.built_tilemap.trees_getting_choped:
        continue
      var path_to_start: Array[Vector2i] = self.get_cell_path(collector_map_position, cell) # to cell
      var path_from_start_to_end: Array[Vector2i] = self.get_cell_path(cell, parent_building_map_position) # from cell to building
      var new_job: Job = Job.new(path_to_start, path_from_start_to_end, ResourceConfig.Resources.TREES)
      jobs.append(new_job)
      break # terminate if tree found, get closest tree by distance not path

  return jobs


# loads resources for a lumberjack collector
func chop_tree(job: Job) -> void:
  if self.built_tilemap == null or self.action_set == null or self.storage == null:
    push_error("Mising nodes in chop_tree, Collector.gd")
    return
  var cell: Vector2i = job.path_from_start_to_end[0]
  var cell_data: TileData = self.built_tilemap.get_cell_tile_data(cell)
  if cell_data == null or cell_data.get_custom_data(self.built_tilemap.is_tree) == false:
    return
  self.visible = true
  self.action_set.action_state = self.action_set.ActionStates.WORK
  await self.sleep(self.load_or_unload_time)
  if self.paused:
    await self.unpaused
  self.built_tilemap.set_cell(cell)
  self.built_tilemap.trees_getting_choped.erase(cell)
  self.action_set.action_state = self.action_set.ActionStates.IDLE
  self.storage.set_storage_item_amount(ResourceConfig.Resources.TREES, 1)
