@tool

extends BaseComponent

class_name CommandableComponent

@export var checkpoint_scene: PackedScene = preload("res://Assets/World/Buoy/Buoy2D.tscn")

@onready var checkpoints: Node = self.get_node("Checkpoints")
@onready var terrain_tilemap: TerrainTileMap = self.get_node("/root/Main/TerrainTileMap") if not Engine.is_editor_hint() else null
@onready var building_context: BuildingContext = self.get_node("/root/Main/GameContextManager/BuildingContext") if not Engine.is_editor_hint() else null
@onready var commandable_object: WorldThing2D = self.get_parent() as WorldThing2D if not Engine.is_editor_hint() else null

var move_by_cell: MoveByCellComponent

signal checkpoint_added



func set_components(new_components: Array[BaseComponent]) -> void:
  for component in new_components:
    if component is MoveByCellComponent:
      self.move_by_cell = component

  self.movement_loop()

func handle_context_input(event: InputEvent):
  if event is InputEventMouseButton:
    if event.pressed:
      if event.button_index == MOUSE_BUTTON_RIGHT:
        self.add_checkpoint() # fire and forget

func add_checkpoint():
  var click_cell_position := self.terrain_tilemap.local_to_map(terrain_tilemap.to_local(self.get_global_mouse_position()))
  var path_to_checkpoint = self.move_by_cell.pathfinding.get_path_to_dest(terrain_tilemap.local_to_map(self.global_position), click_cell_position, true, true)
  # if the shift key is not pressed, delete all buoys
  if not Input.is_key_pressed(KEY_SHIFT):
    for checkpoints in self.checkpoints.get_children():
      checkpoints.queue_free()
  self.move_by_cell.cancel_move() # stop move
  if self.move_by_cell.pathfinding.is_point_solid(click_cell_position) or path_to_checkpoint == null:
    return
  # add a new checkpoint
  var checkpoint: StaticBody2D = self.checkpoint_scene.instantiate()
  self.checkpoints.add_child(checkpoint)
  checkpoint.global_position = terrain_tilemap.map_to_local(click_cell_position)
  self.checkpoint_added.emit()

func movement_loop() -> void:
  while true:
    if self.move_by_cell == null:
      return
    if self.checkpoints.get_child_count() <= 0:
      await self.checkpoint_added
    var checkpoint = self.checkpoints.get_child(0)
    var cell_position: Vector2i = self.terrain_tilemap.local_to_map(self.commandable_object.global_position)
    var checkpoint_cell_position: Vector2i = self.terrain_tilemap.local_to_map(checkpoint.global_position)
    var path = self.move_by_cell.pathfinding.get_path_to_dest(cell_position, checkpoint_cell_position, true, true)
    await self.move_by_cell.move(path)
    # check if the checkpoint was not yet freed
    if checkpoint != null:
      if cell_position != checkpoint_cell_position:
        continue
      self.checkpoints.remove_child(checkpoint)
      checkpoint.queue_free()
