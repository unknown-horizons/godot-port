@tool

extends BaseComponent

class_name Collector

class Job:
  var path_to_start: Array[Vector2i]
  var path_from_start_to_end: Array[Vector2i]
  var resource: StringName
  var amount: int

  func _init(path_to_start: Array[Vector2i], path_from_start_to_end: Array[Vector2i], resource: StringName, amount: int) -> void: #, building_from: Building2D, building_to: Building2D):
    self.path_to_start = path_to_start
    if path_from_start_to_end.size() == 0:
      push_error("Job has no path_from_start_to_end: %s" % self) #path_from_start_to_end
    self.path_from_start_to_end = path_from_start_to_end
    self.resource = resource
    self.amount = amount
  
  func _to_string() -> String:
    if self.path_to_start == [] or self.path_from_start_to_end == []:
      return "Resource: %s" % self.resource
    return "Resource: %s, From: %s, To: %s" % [self.resource, self.path_to_start[-1], self.path_from_start_to_end[-1]]

const CollectorTypes: Dictionary[StringName, StringName] = {
  BUILDING_COLLECTOR   = &"BUILDING_COLLECTOR",
  LUMBERJACK_COLLECTOR = &"LUMBERJACK_COLLECTOR",
  FIELD_COLLECTOR      = &"FIELD_COLLECTOR",
  FISH_COLLECTOR       = &"FISH_COLLECTOR",
}


@export var baseclass: String  # TODO: not used yet
@export var radius: int = -1   # radius how far can the collector walk. If -1 - use the home building radius
@export var velocity: float    # TODO: not used yet
## whether to show while loading
@export var show_while_loading: bool = false

@onready var built_tilemap: BuiltTileMap = self.get_node("/root/Main/BuiltTileMap") if not Engine.is_editor_hint() else null
@onready var home_building: Building2D = self.get_parent() if not Engine.is_editor_hint() else null

# var building_from: Building2D
# var building_to: Building2D

# var resource: StringName = ResourceConfig.Resources.NONE
# var amount: int = 0

var load_or_unload_time: float = 2

var building_storage: StorageComponent

var storage: SizedStorageComponent
var move_by_cell: MoveByCellComponent
var action_set: BuildingActionSet

var collector_type: String = self.CollectorTypes.BUILDING_COLLECTOR:
  set(value):
    collector_type = value

var cell_position: Vector2i:
  get():
    return self.built_tilemap.local_to_map(self.global_position) if self.built_tilemap != null else Vector2i.ZERO
  set(value):
    self.global_position = self.built_tilemap.map_to_local(value)

var effective_radius: int: 
  get():
    return self.radius if self.radius != -1 or self.home_building == null else self.home_building.radius

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
    var storage_component = component as StorageComponent
    if storage_component != null and self.building_storage == null:
      self.building_storage = storage_component
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


## Returns the best possible job at the moment
func get_best_job() -> Job:
  if self.building_storage == null:
    return null
  var collector_map_position: Vector2i = self.cell_position
  var best_job: Job = null
  var best_job_score: float = -1
  var jobs: Array[Job] = []
  match self.collector_type:
    self.CollectorTypes.LUMBERJACK_COLLECTOR:
      jobs = self.get_jobs_for_lumberjack_collector()
    self.CollectorTypes.BUILDING_COLLECTOR, self.CollectorTypes.FIELD_COLLECTOR, self.CollectorTypes.FISH_COLLECTOR:
      jobs = self.get_jobs_for_building_collector()

  for job in jobs:
    if job == null:
      continue
    var score: float = 1 - (len(job.path_to_start) + len(job.path_from_start_to_end)) / float(self.effective_radius) / 2
    score += clamp((randf_range(-0.1, 0.1)), 0, 1) # add some randomness and clamp from 0 to 1
    if score >= best_job_score:
      best_job = job
      best_job_score = score

  var collector_building_at = self.built_tilemap.building_position_to_building.get(collector_map_position, null)
  if best_job == null and collector_building_at != self.home_building: # if there is no job, go home if not home
    var path_home: NavPath = null
    if collector_building_at != null: # use path cached in current building if can
      path_home = collector_building_at.get_path_to_building(self.home_building, self.move_by_cell.pathfinding)
    else:
      path_home = self.built_tilemap.get_cell_position_to_building_path(collector_map_position, self.home_building, self.move_by_cell.pathfinding)

    if path_home != null:
      best_job = Job.new([collector_map_position], path_home.path, ResourceConfig.Resources.NONE, 0)
    else:
      push_error("No path from %s to %s" % [collector_map_position, self.home_building])

  return best_job


static func get_adjusted_position_for_start(position: Vector2i, path: Array[Vector2i]) -> Vector2i:
  if path.size() == 0:
    return position
  var starting_point := path[0]
  if (position.distance_to(starting_point) > 3):
    push_error("Unexpected start position: collector.cell_position: %s, job.path_to_start[0]: %s" % [position, starting_point])
  return starting_point

## the loop for the collecting logic, called at start
func collecting_loop() -> void:
  while true:
    if self.paused:
      await self.unpaused
    var job: Job = await self.wait_for_job()
    if self.collector_type == self.CollectorTypes.LUMBERJACK_COLLECTOR:
      self.built_tilemap.trees_getting_choped[job.path_from_start_to_end[0]] = null

    self.cell_position = Collector.get_adjusted_position_for_start(self.cell_position, job.path_to_start) # collector is on one of the building's tile, move it to startnig position to start the journey
    await self.move_by_cell.move(job.path_to_start)

    await self.load_resources(job)

    self.cell_position = Collector.get_adjusted_position_for_start(self.cell_position, job.path_from_start_to_end) # adjust collector position within building before heading out
    await self.move_by_cell.move(job.path_from_start_to_end)

    await self.unload_resources(job)

static var last_frame = 0

func wait_for_job() -> Job:
  self.visible = false
  var best_job: Job = self.get_best_job()
  while best_job == null:
    # await GameStats.game_stats_resource.resources_changed
    await sleep(1) # check again in 1 second
    while Engine.get_physics_frames() - last_frame <= 10:
      await get_tree().process_frame # max 1 get_best_job per frame (across all collectors), skip one frame if someone used it
    last_frame = Engine.get_physics_frames()
    #print(last_frame)
    if self.paused:
      await self.unpaused
    best_job = self.get_best_job()
  return best_job

func load_resources(job: Job) -> void:
  match self.collector_type:
    self.CollectorTypes.LUMBERJACK_COLLECTOR:
      await self.chop_tree(job)
    self.CollectorTypes.BUILDING_COLLECTOR, self.CollectorTypes.FIELD_COLLECTOR, self.CollectorTypes.FISH_COLLECTOR:
      await self.load_resources_for_building_collector(job)

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
  if (self.collector_type in [self.CollectorTypes.BUILDING_COLLECTOR, self.CollectorTypes.FIELD_COLLECTOR, self.CollectorTypes.FISH_COLLECTOR]) == false:
    push_error("Wrong function called for this collector. Collector: %s, get_jobs_for_building_collector" % self.collector_type)
    return []
  if self.building_storage == null or self.built_tilemap == null or self.home_building == null:
    push_error("Mising nodes in Collector.gd, get_jobs_for_building_collector")
    return []

  var collector_map_position: Vector2i = self.built_tilemap.local_to_map(self.global_position)

  var buildings_in_radius := self.home_building.get_buildings_in_radius(self.effective_radius)

  var partner_buildings: Array[Building2D] = [] # select potential partner buildings
  for other_building: Building2D in buildings_in_radius:
    match self.collector_type: # limit partner buildings based on their baseclass and our collector type
      CollectorTypes.BUILDING_COLLECTOR:
        if other_building.baseclass == "nature.Field" or other_building.baseclass == "nature.Fish":
          continue # building collectors don't collect from fields or fish
      CollectorTypes.FIELD_COLLECTOR:
        if other_building.baseclass != "nature.Field":
          continue # and field collectors don't collect from buildings
      CollectorTypes.FISH_COLLECTOR:
        if other_building.baseclass != "nature.Fish":
          continue # and fish collectors collect only from fish

    if other_building.id in ["BUILDINGS." + BuildingConfig.Buildings.WAREHOUSE, "BUILDINGS." + BuildingConfig.Buildings.STORAGE]:
      partner_buildings.append(other_building) # always add storages as partner buildings
      continue

    var resources_to_carry_in = Utils.intersect_dicts(self.home_building.resources_consumed, other_building.resources_produced)
    if resources_to_carry_in.size() == 0:
      continue # no resources produced by other building to take from it
    partner_buildings.append(other_building)

  # build all jobs: take out to storage (warehouse/storage tent) resource (if any), bring in resources from other buildings and storages
  var jobs: Array[Job] = []
  # var path_to_home: Array[Vector2i] = []
  for other_building in partner_buildings:
    var navpath_to_building_from_home: NavPath = self.home_building.get_path_to_building(other_building, self.move_by_cell.pathfinding)
    if navpath_to_building_from_home == null:
      continue
    var path_to_building_from_home := navpath_to_building_from_home.path
    if path_to_building_from_home.size() - 1 > self.effective_radius: # the max path length excluding starting cell (on buildings) 
      continue

    if other_building.id in ["BUILDINGS." + BuildingConfig.Buildings.WAREHOUSE, "BUILDINGS." + BuildingConfig.Buildings.STORAGE]:
      # the partner_building is a storage - create jobs for taking out the resources produced at home_building
      var resources_produced_amounts := self.home_building.get_resources_produced_amounts()
      for resource in resources_produced_amounts.keys():
        var resource_amount = resources_produced_amounts[resource]
        if resource_amount > 0:
          var path_to_loading_site: NavPath = NavPath.new([])
          var take_out_job: Job = Job.new(path_to_loading_site.path, path_to_building_from_home, resource, resource_amount) # resource take out to storage job
          print("  Potential job: take out %s from %s to %s" % [resource, self.home_building.__repr__, other_building.__repr__])
          jobs.append(take_out_job)

    for resource in self.home_building.resources_consumed.keys():
      if self.home_building.get_resource_amount(resource) >=  self.home_building.get_max_resource_amount(resource):
        continue # incoming storage is full - don't bring in more
      # for all partner buildings (including storages) create jobs to bring in resources for consumption
      if other_building.resources_consumed.has(resource):
        continue # do not take resource from other building if it consumes it
      var resource_amount := other_building.get_resource_amount(resource)
      if resource_amount > 0:
        var collector_building_at: Building2D = self.built_tilemap.building_position_to_building.get(collector_map_position, null)
        if collector_building_at == null:
          push_error("Collector is not in any buildings: %s" % collector_map_position)
          continue
        var path_to_loading_site := collector_building_at.get_path_to_building(other_building, self.move_by_cell.pathfinding)
        # note: path_to_loading_site is looked up through building. This is by design to save on pathfinding costs
        if path_to_loading_site == null:
          push_warning("Cannot reach loading site (%s) from current location (%s)" % [collector_building_at.__repr__, other_building.__repr__])
        else:
          var path_to_home_from_building := path_to_building_from_home.duplicate(); path_to_home_from_building.reverse()
          var bring_in_job: Job = Job.new(path_to_loading_site.path, path_to_home_from_building, resource, resource_amount)
          print("  Potential job: bring in %s from %s to %s" % [resource, other_building.__repr__, self.home_building.__repr__])
          jobs.append(bring_in_job)


  # var new_job: Job = Job.new(path_to_start, path_home_from_other_building, resource)
  # var new_job: Job = Job.new(path_to_start, path_from_home_to_consumer, resource)

  return jobs

## loads resources for a building collector
func load_resources_for_building_collector(job: Job) -> void:
  self.visible = self.show_while_loading
  var building: Building2D = self.built_tilemap.building_position_to_building.get(job.path_from_start_to_end[0])
  if building == null:
    return
  var needed_resource_amount: int = 0
  if building == self.home_building:
    needed_resource_amount = self.building_storage.get_storage_item_amount(job.resource)
  else:
    needed_resource_amount = self.building_storage.get_max_capacity(job.resource) - self.building_storage.get_storage_item_amount(job.resource)
  var resource_amount: int = await building.load_resource(job.resource, needed_resource_amount)
  if self.paused:
    await self.unpaused
  self.storage.set_storage_item_amount(job.resource, resource_amount)


## returns all possible jobs for a lumberjack collector
func get_jobs_for_lumberjack_collector() -> Array[Job]:
  if self.collector_type != self.CollectorTypes.LUMBERJACK_COLLECTOR:
    push_error("Wrong function called for this collector. Collector: %s, get_jobs_for_lumberjack_collector" % self.collector_type)
    return []
  if self.built_tilemap == null or self.home_building == null or self.building_storage == null:
    push_error("Mising nodes in get_jobs_for_lumberjack_collector, Collector.gd")
  if self.building_storage.get_storage_item_amount(ResourceConfig.Resources.TREES) >= self.building_storage.get_max_capacity(ResourceConfig.Resources.TREES):
    return []
  var collector_map_position: Vector2i = self.cell_position
  var cells_in_radius_rect: Rect2i = self.home_building.oriented_rect.grow(self.effective_radius)
  var jobs: Array[Job] = []
  # find all trees and create a job for each
  for y in range(cells_in_radius_rect.position.y, cells_in_radius_rect.end.y):
    for x in range(cells_in_radius_rect.position.x, cells_in_radius_rect.end.x):
      var cell := Vector2i(x, y)
      if Utils.distance_to_rect_L1(cell, cells_in_radius_rect) > self.effective_radius:
        continue
      var cell_data: TileData = self.built_tilemap.get_cell_tile_data(cell)
      if cell_data == null:
        continue
      if cell_data.get_custom_data(self.built_tilemap.is_tree) == true:
        if cell in self.built_tilemap.trees_getting_choped:
          continue
        var path_to_start: Array[Vector2i] = self.get_cell_path(collector_map_position, cell) # to cell
        var path_from_start_to_end: Array[Vector2i] = self.get_cell_path(cell, self.home_building.cell_position) # from cell to building
        if path_to_start == [] or path_from_start_to_end == []:
            continue
        var new_job: Job = Job.new(path_to_start, path_from_start_to_end, ResourceConfig.Resources.TREES, 1)
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
  self.built_tilemap.set_cell(cell, -1)
  self.built_tilemap.trees_getting_choped.erase(cell)
  self.action_set.action_state = self.action_set.ActionStates.IDLE
  self.storage.set_storage_item_amount(ResourceConfig.Resources.TREES, 1)
