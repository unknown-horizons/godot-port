extends Node
#
#var Farm2D = preload("res://Assets/World/Buildings/Agricultural/Farm2D/Farm2D.tscn")
#var WareHouse = preload("res://Assets/World/Buildings/WareHouse2D/ware_house2D.tscn")

var building_to_build = null

const road = "road"


func set_building_to_build(building):
  building_to_build = building



#func get_building_id(building_name: String) -> int:
  #return Buildings.get(building_name)
