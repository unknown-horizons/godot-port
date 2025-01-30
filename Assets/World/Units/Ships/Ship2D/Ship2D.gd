extends Unit2D

class_name Ship2D

@export var buoy: PackedScene = preload("res://Assets/World/Buoy/Buoy2D.tscn")

@onready var buoys: StaticBody2D = self.get_parent().get_node("Buoys")
@onready var terrain_tilemap: TerrainTileMap = self.get_parent().get_parent()
@onready var pathfinding: Pathfinding = self.get_node("/root/Main/Pathfinding")
signal buoy_added

func _ready():
  movement_loop()

func _unhandled_input(event):
  if event is InputEventMouseButton:
    if event.pressed == true:
      if event.button_index == MOUSE_BUTTON_RIGHT:
        add_visit_point() # fire and forget
      # if event.button_index == MOUSE_BUTTON_RIGHT:
      #   self.is_moving = false
      #   for buoy in buoys.get_children():
      #     buoy.queue_free()

func add_visit_point():
  var mouse_pos: Vector2 = terrain_tilemap.get_global_mouse_position()
  if pathfinding.ship_pathfinding.is_point_solid(terrain_tilemap.local_to_map(mouse_pos)):
    return
  # if the shift key is not pressed, delete all buoys
  if not Input.is_key_pressed(KEY_SHIFT):
    self.is_moving = false # stop the current ship movement.
    for buoy in buoys.get_children():
      buoy.queue_free()
  # add a new buoy
  var buoy_inst: StaticBody2D = buoy.instantiate()
  buoys.add_child(buoy_inst)
  buoy_inst.global_position = terrain_tilemap.map_to_local(terrain_tilemap.local_to_map(mouse_pos))
  buoy_added.emit()

func movement_loop():
  while true:
    if buoys.get_child_count() <= 0:
      await buoy_added
    var buoy = buoys.get_child(0)
    var path_or_null = pathfinding.ship_pathfinding.get_path_to_dest(self.global_position, buoy.global_position, false, false)
    if path_or_null != null:
      path_or_null.pop_front()
      await self.move("Move", path_or_null)
    # check if the child was not yet freed
    if buoy != null:
      buoys.remove_child(buoy)
      buoy.queue_free()
