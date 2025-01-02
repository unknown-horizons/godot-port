extends Node2D

class_name ProductionBuilding2D

#@export_category("ProductionBuilding2D")
@export var game_name: String
@export var max_storage_capacity: int = 10

@export_group("time")
@export var processing_time: int = 10
@export var load_or_unload_time: float = 2

@export_group("product")
@export var output_product: String
@export_subgroup("input product")
@export var input_product: String = ""
@export var needs_intake_product: bool = false

@onready var prod_timer: Timer = self.get_node("ProdTimer")
@onready var carrier: Carrier = self.get_node("Carrier")
@onready var tooltip: Control = self.get_node("ItemProducedTooltip")
@onready var product_amount_placeholder: Label = tooltip.get_node("Background/HBoxContainer/ItemAmountContainer/AmountPlaceholder")

var closest_warehouse_path: Array = []
var number_of_output_products = 0
var number_of_intake_products = 0


func setup_building():
  self.get_parent().register_building(self)
  var closest_warehouse_path_or_null = find_closest_warehouse()
  if closest_warehouse_path_or_null != null:
    closest_warehouse_path = closest_warehouse_path_or_null
    carrier.path = closest_warehouse_path



func show_tooltip_animation(amount: int):
  tooltip.visible = true
  product_amount_placeholder.text = str(amount)
  var initial_pos = tooltip.position
  var float_tween = self.create_tween().bind_node(self)
  float_tween.tween_property(tooltip, "position", tooltip.position - Vector2(0,32), 2)
  await float_tween.finished
  float_tween.kill()
  tooltip.visible = false
  tooltip.position = initial_pos



func produce_product():
  if self.needs_intake_product:
    if self.number_of_intake_products > 0:
      self.number_of_intake_products -= 1
    else:
      return

  if self.number_of_output_products < 10:
    self.number_of_output_products += 1

  show_tooltip_animation(1) # fire and forget



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



func new_building_built(building):
#check if building is warehouse
  if building.game_name == "warehouse":
    var path_to_warehouse = self.get_parent().get_path_to_dest(self.position, building.position)
    if path_to_warehouse != null and (len(path_to_warehouse) < len(closest_warehouse_path) or len(closest_warehouse_path) == 0):
      closest_warehouse_path = path_to_warehouse
      carrier.path = closest_warehouse_path



func road_built():
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
