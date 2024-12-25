extends ProductionBuilding2D

class_name Farm2D

#@export_category("Farm2D")
@export var proccesing_time: int = 10



func _ready():
  self.building_setup()
  prod_timer.start(proccesing_time)



func _on_prod_timer_timeout():
  if self.needs_intake_product:
    if self.number_of_intake_products > 0:
      self.number_of_intake_products -= 1
    else:
      return

  if self.number_of_output_products < 10:
    self.number_of_output_products += 1

  resource_produced.emit(output_product, 1)
