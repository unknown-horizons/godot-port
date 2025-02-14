extends InventorySlot

class_name SelectResourceButton

@onready var built_tilemap: BuiltTileMap = self.get_node("/root/Main/BuiltTileMap")

func _process(_delta):
  if self.is_visible_in_tree():
    if self.resource_type:
      var resource_amount = GameStats.game_stats_resource.resources.get(resource_type)
      if resource_amount: # there might be no resource key yet because the it is created when the resource first is stored
        self.resource_amount = resource_amount
      else:
        self.resource_amount = 0
      var warehouse_poses = built_tilemap.building_name_to_building_poses.get("warehouse")
      if warehouse_poses != null and len(warehouse_poses) > 0:
        var warehouse = built_tilemap.building_position_to_building.get(warehouse_poses[0])
        self.limit = warehouse.storage_capacity