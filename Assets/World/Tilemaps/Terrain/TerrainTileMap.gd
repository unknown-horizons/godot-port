extends TileMapLayer

class_name TerrainTileMap

## use to get all cells of terrain split into categories
func get_terrain_points() -> Dictionary:
  var terrain_points: Dictionary = {"Grass": {}, "Beach": {}, "Shallow": {}, "Deep": {}}
  for cell in self.get_used_cells():
    var tile_data: TileData = self.get_cell_tile_data(cell)
    if tile_data != null and tile_data.terrain != null:
      terrain_points.get(self.tile_set.get_terrain_name(tile_data.terrain_set, tile_data.terrain))[cell] = null
  return terrain_points
