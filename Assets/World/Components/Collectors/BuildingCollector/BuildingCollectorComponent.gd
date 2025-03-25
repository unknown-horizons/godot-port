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

var storage_component: SlotStorageComponent = null
var production_line_components: Array[ProductionLineComponent] = []


var resource: ResourceConfig.Resources = ResourceConfig.Resources.NONE
var resource_amount: int = 0

func _ready():
  if built_tilemap == null:
    built_tilemap = self.get_node("/root/Main/BuiltTileMap")
  # setup components
  var child_components: Array[BaseComponent] = []
  for component in self.get_children():
    child_components.append(component)
  for component in child_components:
    component.set_components(child_components)

func set_components(components: Array[BaseComponent]):
  for component in components:
    if component is SlotStorageComponent:
      storage_component = component
    if component is ProductionLineComponent:
      production_line_components.append(component)
  bring_resources_loop()

## Checks if the resource is needed by any of the production line components
func is_resource_needed(resource: ResourceConfig.Resources) -> bool:
  for production_line_component in production_line_components: # go through all the production line components
    if production_line_component.consumes.has(resource): # if the production line component consumes the resource,
      return true # then return true
  return false # if no production line component consumes the resource, return false

## Returns if the building has the needed resource and produces it[br]
## Note: For now, it will return true if the building produces the needed resource but not if is a warehouse and has the resource
func should_collect_resource_from_building(building: WorldThing2D, needed_resource: ResourceConfig.Resources) -> bool:
  if building == null: # if the building is null, then return false
    return false
  var produces_needed_resource: bool = false # by default the building does not produce the needed resource
  var currently_has_resource: bool = false # by default the building does not have the needed resource
  for building_component in building.get_children(): # loop through the components of the building and check if can collect the needed resource

    if building_component is SlotStorageComponent: # if the component is a storage component
      var needed_resource_amount = building_component.storage.get(needed_resource) # get the amount of the needed resource
      if needed_resource_amount != null and needed_resource_amount > 0: # if the building has the needed resource,
        currently_has_resource = true # set the currently_has_resource to true
    
    if building_component is ProductionLineComponent: # if the component is a production line component,
      var produced_resource = building_component.produces.keys()[0] # get the resource produced by the building
      produces_needed_resource = produced_resource == needed_resource # check if the resource produced is the needed resource
  return produces_needed_resource and currently_has_resource # return if the building produces the needed resource and currently has it.

func get_resource_order(res_1: ResourceConfig.Resources, res_2: ResourceConfig.Resources) -> bool:
  return storage_component.storage[res_1] < storage_component.storage[res_2]


func bring_resources_loop():
  while true:
    # wait until there are resources needed
    self.visible = false
    var needed_resources: Array[ResourceConfig.Resources] = get_needed_resources()
    while len(needed_resources) <= 0:
      await storage_component.storage_changed
      needed_resources = get_needed_resources()
    # set the building to collect from and the resource needed to be collected, Note: We may not put the script into a function because we need to set two vars
    var building_to_collect_from: WorldThing2D = null
    for resource_needed in needed_resources:
      building_to_collect_from = get_building_to_collect_from(resource_needed)
      if building_to_collect_from != null:
        resource = resource_needed
        break
    
    if building_to_collect_from == null: # if there is no building to collect from, then go nowhere
      continue

    # go to the building to collect from
    self.visible = true
    await move_by_cell.move_to_dest(building_to_collect_from.global_position)
    # collect the resource
    await collect_resource_from_building(building_to_collect_from, resource)
    # go back
    self.visible = true
    await move_by_cell.move_to_dest(storage_component.global_position)
    # drop the resource
    await unload_resource()


## Returns an array of the needed resources that is sorted by their amount least to greatest
func get_needed_resources() -> Array[ResourceConfig.Resources]:
  var sorted_needed_resources: Array[ResourceConfig.Resources] = [] # declare an sorted array of the needed resources
  for resource in storage_component.storage.keys(): # go through all the resources that can be stored in the storage
    if is_resource_needed(resource): # if the resource is needed,
      sorted_needed_resources.append(resource) # add the resource to the sorted array, Note: we will sort the array later
  sorted_needed_resources.sort_custom(get_resource_order) # sort the array by the resource amount in the storage.
  return sorted_needed_resources

## Finds the closest building that produces the needed resource, Note: For now, we will only collect from production buildings and not warehouses
func get_building_to_collect_from(needed_resource: ResourceConfig.Resources = resource) -> WorldThing2D:
  if built_tilemap == null: # if the built tilemap is null, then return null
    return null
  var closest_building: WorldThing2D = null # declare the closest building var to null
  var distance_to_building: int = 0 # declare the distance to the building var 
  for building in built_tilemap.building_position_to_building.values(): # loop through the buildings
    if should_collect_resource_from_building(building, needed_resource): # if the building has the needed resource and it is its output,
      var path_to_building = move_by_cell.pathfinding.get_path_to_dest(self.global_position, building.global_position) # get the path to the building.
      if path_to_building != null and (closest_building == null or len(path_to_building) < distance_to_building): # if the building is closer than the last closest building,
        closest_building = building # set the closest building to the current building,
        distance_to_building = len(path_to_building) # and set the new distance to the building to collect from
  return closest_building

## Collects the resource from the building if it can be collected from, Note: will not collect from warehouses for now
func collect_resource_from_building(building: WorldThing2D, needed_resource: ResourceConfig.Resources = resource):
  if should_collect_resource_from_building(building, needed_resource) == false: # if we should not collect the resource from the building,
    return # then return(don't collect the resource)
  
  self.visible = false
  var building_storage: SlotStorageComponent = null # declare the building storage var to null
  for building_component in building.get_children(): # loop through the components and get the storage component
    if building_component is SlotStorageComponent:
      building_storage = building_component
  var amount_needed: int = storage_component.storage[resource] # get the amount needed, Note: the building has the needed resource becaouse we should collect from it
  var amount_available: int = building_storage.storage[resource] # get the amount available
  await self.sleep(load_or_unload_time)
  resource_amount = min(amount_needed, amount_available) # set the amount of the resource carrying
  building_storage.set_storage_item_amount(resource, amount_available - resource_amount) # set the amount of the resource in the building

func unload_resource():
  self.visible = false
  await self.sleep(load_or_unload_time)
  storage_component.set_storage_item_amount(resource, storage_component.storage[resource] + resource_amount)
  resource_amount = 0
  resource = ResourceConfig.Resources.NONE
