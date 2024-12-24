extends ProductionBuilding2D

class_name Lumberjack2D

@export var unload_wood_time: int = 2
@export var proccesing_time: int = 10

func _ready():
  self.building_setup()
  #do_production_loop()

#func do_production_loop():
  #await wait_for_tree()
#
  #await produce_wood()
#
  #do_production_loop()
#
#func wait_for_tree():
  #await self.get_tree().create_timer(1).timeout
  #if number_of_output_products > 0:
    #return
  #else:
    #await wait_for_tree()
#
#func produce_wood():
  #await self.get_tree().create_timer(proccesing_time).timeout
  #self.resource_produced.emit(output_product, 1)

func unload_wood():
  await self.get_tree().create_timer(unload_wood_time).timeout
  self.number_of_output_products += 1
  self.resource_produced.emit(output_product, 1)
