extends Node2D

class_name ProductionBuilding2D

#@export_category("ProductionBuilding2D")
@export var game_name: String
@export var output_product: String

@export var max_storage_capacity: int = 10
@export var processing_time: int = 10
@export var load_or_unload_time: float = 2

@export_group("intake product")
@export var input_product: String = ""
@export var needs_intake_product: bool = false

@onready var prod_timer: Timer = get_node("ProdTimer")
@onready var carrier: Carrier = get_node("Carrier")
@onready var item_produced_tool_tip: ItemProducedToolTip = get_node("ItemProducedToolTip")

var closest_warehouse_path: Array = []
var number_of_output_products = 0
var number_of_intake_products = 0

signal resource_produced



func setup_building():
  self.get_parent().register_building(self)
  var closest_warehouse_path_or_null = find_closest_warehouse()
  if closest_warehouse_path_or_null != null:
    closest_warehouse_path = closest_warehouse_path_or_null
    carrier.path = closest_warehouse_path



func produce_product():
  if self.needs_intake_product:
    if self.number_of_intake_products > 0:
      self.number_of_intake_products -= 1
    else:
      return

  if self.number_of_output_products < 10:
    self.number_of_output_products += 1

  resource_produced.emit(output_product, 1)



func find_closest_warehouse():
  var warehouse_poses = self.get_parent().building_name_to_building_poses.get("warehouse")

# make sure there are warehouses
  if warehouse_poses == null:
    return null

  var closest_warehouse_path_yet = null
  for warehouse_pos in warehouse_poses:
    var warehouse_path = self.get_parent().get_path_to_dest(self.position, warehouse_pos)
# check if there is a path
    if warehouse_path == null:
      continue

    if closest_warehouse_path_yet == null or len(warehouse_path) < len(closest_warehouse_path_yet):
      closest_warehouse_path_yet = warehouse_path

  return closest_warehouse_path_yet



func new_building_builded(building):
#check if building is warehouse
  if building.game_name == "Warehouse":
    var path_to_warehouse = self.get_parent().get_path_to_dest(self.position, building.position)
    if path_to_warehouse != null and (len(path_to_warehouse) < len(closest_warehouse_path) or len(closest_warehouse_path) == 0):
      closest_warehouse_path = path_to_warehouse
      carrier.path = closest_warehouse_path



func road_builded():
  var closest_warehouse_path_or_null = find_closest_warehouse()
  if closest_warehouse_path_or_null != null:
    closest_warehouse_path = closest_warehouse_path_or_null
    carrier.path = closest_warehouse_path



func get_resourses_needed() -> Array:
  if needs_intake_product:
    return [input_product, max_storage_capacity - number_of_intake_products]
  else:
    return ["", 0]



func unload_carrier(object_carring: String, amount: int) -> int:
  if object_carring == "":
    await self.get_tree().create_timer(load_or_unload_time / 2).timeout

    number_of_intake_products = min(number_of_intake_products + amount,  max_storage_capacity)

  return 0



func load_carrier() -> Array:
  await self.get_tree().create_timer(load_or_unload_time / 2).timeout

  var amount_to_load = min(number_of_output_products, carrier.max_carry_limit)
  number_of_output_products -= amount_to_load
  return [amount_to_load, self.output_product]
