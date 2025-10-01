extends Resource
## data that all the buildings need

class_name BuildingData

@export var game_name : String
@export var cost: Dictionary[StringName, int] # resource_name to count
@export var building_tile: int
@export var info_tab_widget: PackedScene
