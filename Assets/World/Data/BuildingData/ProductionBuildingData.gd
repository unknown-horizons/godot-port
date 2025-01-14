extends BuildingData

class_name ProductionBuildingData

@export var max_storage_capacity: int = 10

@export_group("time")
@export var processing_time: int = 10
@export var load_or_unload_time: float = 2

@export_group("product")
@export var output_product: ItemData
@export var input_products: Dictionary = {}
