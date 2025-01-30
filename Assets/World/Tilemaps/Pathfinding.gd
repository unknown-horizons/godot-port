extends Node

class_name Pathfinding

@onready var terrain_tilemap: TerrainTileMap = %TerrainTileMap
@onready var built_tilemap: BuiltTileMap = %BuiltTileMap

## pathfinding for ships
@onready var ship_pathfinding: PathFindingManagement2D = PathFindingManagement2D.new(
  %TerrainTileMap,
  false,
  AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE,
  AStarGrid2D.HEURISTIC_MANHATTAN,
  AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN)

## pathfinding for Carriers
@onready var carrier_pathfinding = PathFindingManagement2D.new(%BuiltTileMap, false)

func _ready():
  var terrain_points = terrain_tilemap.get_terrain_points()
  # setup the ship pathfinding
  var water: Array = terrain_points["Deep"].keys().duplicate()
  water.append_array(terrain_points["Shallow"].keys().duplicate())
  ship_pathfinding.set_points_passable(water, true)
  # setup the person pathfinding
  for cell in built_tilemap.get_used_cells():
    var cell_data = built_tilemap.get_cell_tile_data(cell)
    if cell_data != null and built_tilemap.tile_set.get_terrain_name(cell_data.terrain_set, cell_data.terrain) == "DirtRoad":
      carrier_pathfinding.set_point_solid(cell, false)
