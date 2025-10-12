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
@onready var road_pathfinding = PathFindingManagement2D.new(%BuiltTileMap)

## pathfinding for going on all land
@onready var land_pathfinding = PathFindingManagement2D.new(%TerrainTileMap, true, AStarGrid2D.DIAGONAL_MODE_ALWAYS, AStarGrid2D.HEURISTIC_EUCLIDEAN)

func _ready():
  var terrain_points = terrain_tilemap.get_terrain_points()
  # setup the ship pathfinding
  var water: Array = terrain_points["Deep"].keys().duplicate()
  water.append_array(terrain_points["Shallow"].keys().duplicate())
  ship_pathfinding.set_points_passable(water, true)
  # setup the land pathfinding
  var land: Array = terrain_points["Grass"].keys().duplicate()
  land.append_array(terrain_points["Beach"].keys().duplicate())
  self.land_pathfinding.set_points_passable(land, true)

  # setup the person pathfinding
  for cell in built_tilemap.get_used_cells():
    var cell_data = built_tilemap.get_cell_tile_data(cell)
    if cell_data == null or cell_data.terrain_set == -1:
      continue
    if cell_data != null and built_tilemap.tile_set.get_terrain_name(cell_data.terrain_set, cell_data.terrain) == "DirtRoad":
      road_pathfinding.set_point_solid(cell, false)

# func create_pathfinding(terrain: )
