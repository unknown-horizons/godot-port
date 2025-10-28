extends TileMapLayer

class_name TerrainTileMap

## use to get all cells of terrain split into categories
func get_terrain_points() -> Dictionary[String, Dictionary]:
  var terrain_points: Dictionary[String, Dictionary] = {"Grass": {}, "Beach": {}, "Shallow": {}, "Deep": {}}
  for cell in self.get_used_cells():
    var tile_data: TileData = self.get_cell_tile_data(cell)
    if tile_data != null and tile_data.terrain != null:
      terrain_points.get(self.tile_set.get_terrain_name(tile_data.terrain_set, tile_data.terrain))[cell] = null
  return terrain_points

## returns the cells terrain bitmask (DEEP)(SHALLOW)(BEACH)(GRASS)
func get_cell_terrain_bitmask(cell: Vector2i) -> int:
  var cell_bitmask: int = 0 # no tile
  var terrain_tile_data: TileData = self.get_cell_tile_data(cell)
  if terrain_tile_data != null:
    var terrain_name: String = self.tile_set.get_terrain_name(terrain_tile_data.terrain_set, terrain_tile_data.terrain)
    cell_bitmask |= int(terrain_name == "Grass")   << 0
    cell_bitmask |= int(terrain_name == "Beach")   << 1
    cell_bitmask |= int(terrain_name == "Shallow") << 2
    cell_bitmask |= int(terrain_name == "Deep")    << 3
  
  return cell_bitmask
