extends CanvasLayer

#@export var 

signal new_building_selected



func _ready():
  self.visible = true
  new_building_selected.connect(BuildingManager.set_building_to_build)



func start_build_building(building: String):
  new_building_selected.emit(building)
