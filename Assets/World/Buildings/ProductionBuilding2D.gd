extends Building2D
## inherited by all 2D production buildings, it has all the parameters and functions that all production buildings need

class_name ProductionBuilding2D

@onready var built_tilemap: BuiltTileMap = self.get_parent()
@onready var prod_timer: Timer = self.get_node("ProdTimer")
@onready var carrier: Carrier = self.get_node("Carrier")
@onready var tooltip: Control = self.get_node("ItemProducedTooltip")
@onready var product_amount_placeholder: Label = tooltip.get_node("Background/HBoxContainer/ItemAmountContainer/AmountPlaceholder")

var closest_warehouse_path: Array = []
var number_of_output_products = 0
var input_product_storage: Dictionary = {}

func setup_building():
  var closest_warehouse_path_or_null = find_closest_warehouse()
  input_product_storage = self.building_data.input_products.duplicate()
  if closest_warehouse_path_or_null != null:
    closest_warehouse_path = closest_warehouse_path_or_null
    carrier.path = closest_warehouse_path
  # make sure that all input products are added to the input storage and set to 0
  for input_product in self.building_data.input_products.keys():
    input_product_storage[input_product] = 0



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



func is_storage_full() -> bool:
  for resource in self.building_data.input_products.keys():
    if input_product_storage[resource] < self.building_data.max_storage_capacity:
      return false
  return true

func produce_product():
  # check if there are enough input products
  if len(self.building_data.input_products.keys()) > 0:
    for resource in self.building_data.input_products.keys():
      var amount_reqired = self.building_data.input_products[resource]
      if input_product_storage[resource] < amount_reqired:
        return
  # spend the resources
    for resource in self.building_data.input_products.keys():
      var amount_required = self.building_data.input_products[resource]
      input_product_storage[resource] -= amount_required

  if self.number_of_output_products < 10:
    self.number_of_output_products += 1

  show_tooltip_animation(1) # fire and forget



func find_closest_warehouse():
  var warehouse_poses = built_tilemap.building_name_to_building_poses.get("warehouse")

# make sure there are warehouses
  if warehouse_poses == null:
    return null

  var closest_warehouse_path_yet = null
  for warehouse_pos in warehouse_poses:
    var warehouse_path = self.get_node("/root/Main/Pathfinding").carrier_pathfinding.get_path_to_dest(self.position, warehouse_pos)
# check if there is a path
    if warehouse_path == null:
      continue

    if closest_warehouse_path_yet == null or len(warehouse_path) < len(closest_warehouse_path_yet):
      closest_warehouse_path_yet = warehouse_path

  return closest_warehouse_path_yet



func new_building_built(building: Building2D):
  #check if building is warehouse
  if building.building_data.game_name == "warehouse":
    var path_to_warehouse = self.get_node("/root/Main/Pathfinding").carrier_pathfinding.get_path_to_dest(self.position, building.position)
    if path_to_warehouse != null and (len(path_to_warehouse) < len(closest_warehouse_path) or len(closest_warehouse_path) == 0):
      closest_warehouse_path = path_to_warehouse
      carrier.path = closest_warehouse_path

func road_built():
  var closest_warehouse_path_or_null = find_closest_warehouse()
  if closest_warehouse_path_or_null != null:
    closest_warehouse_path = closest_warehouse_path_or_null
    carrier.path = closest_warehouse_path

func needs_resources() -> bool:
  for resource in self.building_data.input_products.keys():
    if input_product_storage[resource] < self.building_data.max_storage_capacity:
      return true
  return false

func get_resourses_needed() -> Dictionary:
  # create a dictionary, needed_product : amount_needed
  var needed_products: Dictionary = {}
  for needed_product in self.building_data.input_products.keys():
    if input_product_storage[needed_product] < self.building_data.max_storage_capacity:
      needed_products[needed_product] = min(self.building_data.max_storage_capacity - input_product_storage[needed_product], carrier.max_carry_limit)
  return needed_products


func unload_carrier(resources_brought: Dictionary) -> Dictionary:
  await self.get_tree().create_timer(self.building_data.load_or_unload_time / 2).timeout

  for resource in resources_brought.keys():
    input_product_storage[resource] = min(resources_brought[resource] + input_product_storage[resource], self.building_data.max_storage_capacity)

  return {}



func load_carrier() -> Dictionary:
  await self.get_tree().create_timer(self.building_data.load_or_unload_time / 2).timeout
  var amount_to_load = min(number_of_output_products, carrier.max_carry_limit)
  number_of_output_products -= amount_to_load
  return {self.building_data.output_product: amount_to_load}
