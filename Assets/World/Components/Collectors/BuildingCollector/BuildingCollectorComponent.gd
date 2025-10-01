extends BaseComponent
## Collects needed resources from buildings and brings them to the parent building.[br]
## Warning: This component was not tested yet

class_name BuildingCollectorComponent

## The built tilemap[br]
## Default: "/root/Main/BuiltTileMap"
@export var built_tilemap: BuiltTileMap = null
@export var load_or_unload_time: float = 2


@onready var move_by_cell: MoveByCellComponent = self.get_node("MoveByCellComponent")
@onready var action_set: CollectorActionSet = self.get_node("CollectorActionSet")
@onready var parent_building: Building2D = self.get_parent()

var sized_storage: SizedStorageComponent = null
var building_storage: StorageComponent = null


class Job:
  var resource: StringName
  var amount: int
  var building: Building2D

  func _init(resource: StringName, amount: int, building: Building2D):
    self.resource = resource
    self.amount = amount
    self.building = building


func _ready():
  if built_tilemap == null:
    built_tilemap = self.get_node("/root/Main/BuiltTileMap")
  # setup components
  var child_components: Array[BaseComponent] = []
  for component in self.get_children():
    child_components.append(component)
    if component is SizedStorageComponent:
      sized_storage = component
  
  for component in child_components:
    component.set_components(child_components)

func set_components(components: Array[BaseComponent]):
  for component in components:
    if component is StorageComponent:
      building_storage = component
  bring_resources_loop()


## Finds the closest building that produces the needed resource, Note: For now, we will only collect from production buildings and not warehouses
func get_building_to_collect_from(needed_resource: StringName) -> Building2D:
  if built_tilemap == null: # if the built tilemap is null, then return null
    return null
  var closest_building: Building2D = null # declare the closest building var to null
  var distance_to_building: int = 0 # declare the distance to the building var 
  for building in built_tilemap.building_position_to_building.values(): # loop through the buildings
    if building.is_resource_available(needed_resource): # if the building has the needed resource and it is its output,
      var path_to_building = move_by_cell.pathfinding.get_path_to_dest(self.global_position, building.global_position) # get the path to the building.
      if path_to_building != null and (closest_building == null or len(path_to_building) < distance_to_building): # if the building is closer than the last closest building,
        closest_building = building # set the closest building to the current building,
        distance_to_building = len(path_to_building) # and set the new distance to the building to collect from
  return closest_building

## Returns the best possible job at the moment
func get_best_job() -> Job:
  var needed_resources: Array[StringName] = parent_building.get_needed_resources()
  for resource in needed_resources:
    var building_to_collect_from: WorldThing2D = get_building_to_collect_from(resource)
    if building_to_collect_from != null:
      var amount_needed: int = building_storage.storage[resource]
      var limited_amount: int = clamp(amount_needed, 0, sized_storage.storage_capacity)
      return Job.new(resource, limited_amount, building_to_collect_from)
  return null


func bring_resources_loop():
  while true:
    # get the job to do
    var job: Job = await wait_for_job()
    # go to the building to collect from
    self.visible = true
    await move_by_cell.move_to_dest(job.building.global_position)
    # collect the resource
    self.visible = false
    await load_resources(job)
    # go back
    self.visible = true
    await move_by_cell.move_to_dest(parent_building.global_position)
    # drop the resource
    self.visible = false
    await unload_resources(job)


## Waits for a job to be available
func wait_for_job() -> Job:
  var best_job: Job = get_best_job()
  while best_job == null:
    await building_storage.storage_changed
    best_job = get_best_job()
  return best_job

## Loads the resources from the building
func load_resources(job: Job) -> void:
  await self.sleep(load_or_unload_time)
  var amount_collected: int = job.building.load_resources(job.needed_resource, job.amount)
  sized_storage.set_storage_item_amount(job.needed_resource, amount_collected)

## Unloads the resources at the building
func unload_resources(job: Job) -> void:
  await self.sleep(load_or_unload_time)
  parent_building.unload_resources(job.needed_resource, sized_storage.storage[job.resource])
  sized_storage.storage = {}
