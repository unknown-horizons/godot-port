extends ProductionBuilding2D

class_name Farm2D

#@export_category("Farm2D")
#@export var proccesing_time: int = 10



func _ready():
  self.setup_building()
  prod_timer.start(self.building_data.processing_time)
