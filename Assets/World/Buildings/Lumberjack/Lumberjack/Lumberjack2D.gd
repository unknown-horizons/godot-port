extends Unit2D

class_name LumberjackWorker2D

var closest_trees: Array = []

@export var choping_down_tree_time: float = 2
@export var speed_px_per_sec: float = 64

@onready var building_parent: Building2D = self.get_parent()
@onready var built_tilemap: BuiltTileMap = self.get_parent().get_parent()

var count_of_objects: int = 0

func _ready():
  self.setup_unit()
  set_closest_trees()
  movement_loop()

func set_closest_trees():
  closest_trees = built_tilemap.get_trees(false)
  if closest_trees.has(closest_trees[0]):
    pass
  closest_trees.sort_custom(is_first_tree_closer)

func is_first_tree_closer(first, second) -> bool:
  if self.global_position.distance_to(first) < self.global_position.distance_to(second):
    return true
  else:
    return false

func is_cell_a_tree(tree_pos: Vector2) -> bool:
  var tile_map_layer: BuiltTileMap = built_tilemap
  var cell_data = tile_map_layer.get_cell_tile_data(tile_map_layer.local_to_map(tree_pos))
  return cell_data != null and cell_data.get_custom_data(tile_map_layer.is_tree)

func is_tree_available_for_choping(tree_pos: Vector2) -> bool:
  return is_cell_a_tree(tree_pos) and not built_tilemap.trees_getting_choped.has(tree_pos)

func walk(where: Vector2):
  var tween_time = self.global_position.distance_to(where) / speed_px_per_sec
  if count_of_objects >= 1:
    self.unit_sprite.play("MoveFull" + str(self.get_sprite_angle(where)))
  else:
    self.unit_sprite.play("Move" + str(self.get_sprite_angle(where)))
  var move_tween: Tween = self.get_tree().create_tween().bind_node(self)
  move_tween.tween_property(self, "global_position", where, tween_time)
  await move_tween.finished
  self.unit_sprite.stop()


func movement_loop():
  while true:
    await wait_for_tree_in_need()
    var tree_pos = get_closest_available_tree()
  # if no tree, then wait and check again
    while tree_pos == null:
      await self.get_tree().create_timer(1).timeout
      tree_pos = get_closest_available_tree()
    lock_tree(tree_pos)
    self.visible = true
    await walk(tree_pos)
    if is_cell_a_tree(tree_pos):
      await chopdown_tree(tree_pos)
    await walk(building_parent.global_position)
    self.visible = false
    await unload()

func wait_for_tree_in_need():
# wait until needs and can go to tree
  while true:
    var wood_amount = building_parent.input_product_storage.get(building_parent.wood_data)
    if wood_amount != null and closest_trees != []:
      if wood_amount < building_parent.building_data.max_storage_capacity:
        return
    await self.get_tree().create_timer(1).timeout

func get_closest_available_tree():
  var closest_tree: Vector2 = closest_trees.pop_front()
  while not is_tree_available_for_choping(closest_tree):
    if len(closest_trees) <= 0:
      return null
    else:
      closest_tree = closest_trees.pop_front()
  return closest_tree

func lock_tree(tree_pos: Vector2) -> void:
  built_tilemap.trees_getting_choped[tree_pos] = null

func chopdown_tree(tree_pos):
  await self.get_tree().create_timer(choping_down_tree_time).timeout
  if not is_cell_a_tree(tree_pos):
    return
  var tile_map_layer: BuiltTileMap = built_tilemap
  tile_map_layer.set_cell(tile_map_layer.local_to_map(tree_pos), -1)
  count_of_objects = 1
  tile_map_layer.trees_getting_choped.erase(tree_pos)

func unload():
  if count_of_objects >= 1:
    await building_parent.unload_wood()
  count_of_objects = 0
