extends BaseComponent
## Collects needed resources from buildings and brings them to the parent building.[br]
## Warning: This component was not tested yet

class_name BuildingCollectorComponent

## The built tilemap[br]
## Default: "/root/Main/BuiltTileMap"
@export var built_tilemap: BuiltTileMap = null
# @export var load_or_unload_time: float = 2


@onready var move_by_cell: MoveByCellComponent = self.get_node("MoveByCellComponent")
@onready var action_set: CollectorActionSet = self.get_node("CollectorActionSet")
@onready var parent_building: Building2D = self.get_parent()

var path_to_warehouse: Array[Vector2] = []

var sized_storage: SizedStorageComponent = null
var building_storage: SlotStorageComponent = null
var production_line_components: Array[ProductionLineComponent] = []

signal storage_changed

class Job:
  static var NONE: Job = Job.new(ResourceConfig.Resources.NONE, 0, null, null)

  var resource: StringName
  var amount: int
  var building_from: Building2D
  var building_to: Building2D

  func _init(resource: StringName, amount: int, building_from: Building2D, building_to: Building2D):
    self.resource = resource
    self.amount = amount
    self.building_from = building_from
    self.building_to = building_to



func _ready():
  super()
  if built_tilemap == null:
    built_tilemap = self.get_node("/root/Main/BuiltTileMap")
  # setup components
  var child_components: Array[BaseComponent] = []
  for component in self.get_children():
    child_components.append(component)
    if component is SizedStorageComponent:
      sized_storage = component

  if self.built_tilemap != null:
    self.built_tilemap.buildings_built.connect(self.set_closest_warehouse)
    self.set_closest_warehouse(built_tilemap.building_position_to_building.values())

func set_components(components: Array[BaseComponent]):
  for component in components:
    if component is SlotStorageComponent:
      self.building_storage = component
      self.building_storage.storage_changed.connect(self.call_storage_changed)
    if component is ProductionLineComponent:
      production_line_components.append(component)
  GameStats.game_stats_resource.resources_changed.connect(self.call_storage_changed)
  bring_resources_loop()

func set_closest_warehouse(new_buildings: Array[Building2D]):
  if built_tilemap == null: # if the built tilemap is null, then return null
    return
  for building in new_buildings: # loop through the buildings
    var warehouse: Warehouse2D = building as Warehouse2D
    if warehouse: # if the building is a warehouse,
      var path_to_current_warehouse = move_by_cell.pathfinding.get_path_to_dest(self.global_position, building.global_position) # get the path to the warehouse.
      if path_to_current_warehouse == null:
        continue
      if (self.path_to_warehouse == [] or len(path_to_current_warehouse) < len(path_to_warehouse)) and path_to_current_warehouse != null: # if the warehouse is closer than the last closest warehouse,
        self.path_to_warehouse = []
        for cell in path_to_current_warehouse:
          self.path_to_warehouse.append(cell as Vector2)

## Finds the closest building that produces the needed resource, Note: For now, we will only collect from production buildings and not warehouses
func get_building_to_collect_from(needed_resource: StringName) -> Building2D:
  if built_tilemap == null: # if the built tilemap is null, then return null
    return null
  var closest_building: Building2D = null # declare the closest building var to null
  var distance_to_building: int = 0 # declare the distance to the building
  for building in built_tilemap.building_position_to_building.values(): # loop through the buildings
    if building.is_resource_available(needed_resource): # if the building has the needed resource and it is its output,
      var path_to_building = move_by_cell.pathfinding.get_path_to_dest(self.global_position, building.global_position) # get the path to the building.
      if path_to_building != null and (closest_building == null or len(path_to_building) < distance_to_building): # if the building is closer than the last closest building,
        closest_building = building # set the closest building to the current building,
        distance_to_building = len(path_to_building) # and set the new distance to the building to collect from
  return closest_building

## merge multiple signals for await either
func call_storage_changed():
  storage_changed.emit() 

## Returns the best possible job at the moment
func get_best_job() -> Job:
  var best_job: Job = null
  var job_score: int = -1000000
  for resource in self.building_storage.storage.keys():
    var carry_in: bool = true
    for production_line in self.production_line_components:
      if production_line.produces.has(resource):
        carry_in = false
        break

    var new_job: Job = Job.new(resource, 0, null, null)
    var max_amount_to_carry: int = 0
    if carry_in:
      max_amount_to_carry = self.building_storage.max_capacity[resource] - self.building_storage.storage[resource]
      new_job.building_to = self.parent_building
      var building_to_collect_from: WorldThing2D = get_building_to_collect_from(resource)
      if building_to_collect_from != null:
        new_job.building_from = building_to_collect_from
    elif path_to_warehouse != []:
      max_amount_to_carry = self.building_storage.storage[resource]
      new_job.building_from = self.parent_building
      new_job.building_to = self.built_tilemap.building_position_to_building.get(self.path_to_warehouse[-1])

    new_job.amount = clamp(max_amount_to_carry, 0, sized_storage.storage_capacity)
    if new_job.building_from == null or new_job.building_to == null or new_job.amount == 0 or new_job.resource == ResourceConfig.Resources.NONE:
      continue
    var path_to_start = move_by_cell.pathfinding.get_path_to_dest(self.global_position, new_job.building_from.global_position)
    if path_to_start == null:
      continue
    
    var storages: Array = new_job.building_to.get_components(StorageComponent)
    var amount_available = 0
    if new_job.building_to is Warehouse2D:
      amount_available = GameStats.game_stats_resource.resources.get(new_job.resource, 0)
    elif storages == []:
      continue
    else:
      amount_available = storages[0].storage.get(new_job.resource)
    var new_job_score: int = min(new_job.amount, amount_available + 2) - len(path_to_start) /2 
    if new_job_score > job_score:
      best_job = new_job
      job_score = new_job_score

  if best_job == null and self.built_tilemap.building_position_to_building.get(self.global_position) != self.parent_building:
    return Job.new(ResourceConfig.Resources.NONE, 0, self.parent_building, self.parent_building) # go home

  return best_job


func bring_resources_loop():
  while true:
    # get the job to do
    var job: Job = await wait_for_job()
    # go to the building to collect from
    self.visible = true
    await self.move_by_cell.move(job.building_from.global_position)
    # collect the resource
    self.visible = false
    await load_resources(job)
    # go back
    self.visible = true
    await self.move_by_cell.move(job.building_to.global_position)
    # drop the resource
    self.visible = false
    await unload_resources(job)


## Waits for a job to be available
func wait_for_job() -> Job:
  var best_job: Job = get_best_job()
  while best_job == null:
    await self.storage_changed
    if self.paused:
      await self.unpaused
    best_job = get_best_job()
  return best_job

## Loads the resources from the building
func load_resources(job: Job = self.job) -> void:
  if job.building_from == null or job.building_from.is_queued_for_deletion():
    return

  var amount_collected: int = await job.building_from.load_resource(job.resource, job.amount)
  sized_storage.set_storage_item_amount(job.resource, amount_collected)
  if self.paused:
    await self.unpaused

## Unloads the resources at the building
func unload_resources(job: Job = self.job) -> void:
  if job.building_to == null or job.building_to.is_queued_for_deletion():
    return
  await job.building_to.unload_resource(job.resource, sized_storage.storage[job.resource])
  sized_storage.storage = {}
  if self.paused:
    await self.unpaused
