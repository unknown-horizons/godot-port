extends TileMapLayer

class_name SceneTileMapLayer

var tile_coords_to_scene: Dictionary = {}

func set_scene(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0) -> void:
  self.set_cell(coords, source_id, atlas_coords, alternative_tile)
  await self.get_tree().create_timer(0.1).timeout
  tile_coords_to_scene[coords] = self.get_child(self.get_child_count()-1)

func get_scene(coords: Vector2i):
  return tile_coords_to_scene.get(coords)

func remove_scene(coords: Vector2i) -> void:
  self.set_cell(coords, -1)
  tile_coords_to_scene.erase(coords)
