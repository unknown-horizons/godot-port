extends BaseComponent
## Moves the an object by cells
##
## The component moves the object given by the node path(usualy the parent) by cells.

class_name MoveByCellComponent

## The speed of the object in tiles per second
@export var tile_per_sec: float = 2
## The type of allowed movement
@export var allowed_movement: AllowedMovementTypes = AllowedMovementTypes.MOVE_ON_ROAD

## The object this component is moving[br]
## Default: ".."
@export var object_to_be_moved: Node2D = null
## The pathfinding node[br]
## Default: "root/Main/Pathfinding"
@export var pathfinding_node: Pathfinding = null

## The possible types for determining if movement is allowed
enum AllowedMovementTypes {
  ## The value representing movement allowed on water
  MOVE_ON_WATER,
  ## The value representing movement allowed only on road
  MOVE_ON_ROAD,
}

## The possible movement states for the unit.
enum MoveStates {
  ## The value representing no movement.
  IDLE,
  ## The value representing the moving state
  MOVING,
}

var action_set: CollectorActionSet = null

var pathfinding: PathFindingManagement2D = null

## The current movement state.[br]
## Please [b]do not[/b] change the values outside the class.[br]
## [b]Note[/b]: if set, it will update the action set.
var move_state: MoveStates = MoveStates.IDLE:
  set(value):
    var last_state = move_state
    move_state = value
    if last_state != move_state:
      update_action_set()

func _ready():
  if object_to_be_moved == null:
    object_to_be_moved = self.get_node("..")
  if pathfinding_node == null:
    pathfinding_node = self.get_node("/root/Main/Pathfinding")
  if pathfinding_node == null:
    push_warning("Pathfinding node is not found")
  else:
    match allowed_movement:
      AllowedMovementTypes.MOVE_ON_WATER:
        pathfinding = pathfinding_node.ship_pathfinding
      AllowedMovementTypes.MOVE_ON_ROAD:
        pathfinding = pathfinding_node.road_pathfinding

func set_components(components: Array[BaseComponent]):
  for component in components:
    if component is CollectorActionSet:
      action_set = component

func update_action_set():
  if action_set != null:
    match move_state:
      MoveStates.IDLE:
        action_set.collector_action = CollectorActionSet.CollectorActions.IDLE
      MoveStates.MOVING:
        action_set.collector_action = CollectorActionSet.CollectorActions.MOVE

func move(go_to_position: Vector2) -> void:
  if pathfinding == null:
    push_error("Pathfinding is not set and the object is wanted to be moved")
    return
  
  move_state = MoveStates.MOVING
  var path = pathfinding.get_path_to_dest(object_to_be_moved.global_position, go_to_position)
  if path != null:
    path.pop_front() # remove the starting position because the object is already there
    for new_position in path:
      var move_vec: Vector2 = new_position - object_to_be_moved.global_position

      if action_set:
        var direction = rad_to_deg(move_vec.angle_to(Vector2(1, 0)))
        direction = posmod(direction, 360) # make in range of 0-359
        action_set.direction = direction
      
      var move_tween: Tween = self.get_tree().create_tween().bind_node(self)
      move_tween.tween_property(object_to_be_moved, "global_position", new_position, 1/tile_per_sec)
      await move_tween.finished
      if paused:
        await self.unpaused
    object_to_be_moved.global_position = go_to_position # remove any tween errors
  move_state = MoveStates.IDLE
