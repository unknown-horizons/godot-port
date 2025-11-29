@tool

extends InventorySlot

class_name SelectResourceButton

@onready var built_tilemap: BuiltTileMap = self.get_node("/root/Main/BuiltTileMap") if not Engine.is_editor_hint() else null

func _process(_delta):
  if self.is_visible_in_tree():
    if self.resource_type:
      var resource_amount = GameStats.game_stats_resource.resources.get(resource_type)
      if resource_amount: # there might be no resource key yet because the it is created when the resource first is stored
        self.resource_amount = resource_amount
      else:
        self.resource_amount = 0
      var warehouses_cells = built_tilemap.building_name_to_cell_coords.get("warehouse", [])
      if len(warehouses_cells) > 0:
        var warehouse = built_tilemap.building_position_to_building.get(warehouses_cells[0])
        self.limit = warehouse.storage_capacity
