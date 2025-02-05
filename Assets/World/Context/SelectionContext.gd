extends BaseContext
## Is responsible for doing selection

class_name SelectionContext

@onready var built_tilemap: BuiltTileMap = %BuiltTileMap
@onready var selection_box: SelectionBox = self.get_node("CanvasLayer/SelectionBox")
@onready var object_selected_context: ObjectSelectedContext = self.get_parent().get_node("ObjectSelectedContext")

var is_selecting: bool = false
var selection_rect: Rect2 = Rect2()

func _unhandled_input(event):
  if self.is_active or object_selected_context.is_active:
    if event is InputEventMouseButton:
      if event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed == true:
          # print(built_tilemap.get_global_mouse_position())
          selection_rect.position = built_tilemap.get_global_mouse_position()
          selection_box.visible = true
          is_selecting = true
        elif is_selecting:
          # print(built_tilemap.get_global_mouse_position())
          selection_rect.end = built_tilemap.get_global_mouse_position()
          selection_rect = selection_rect.abs()
          # print(selection_rect.position, selection_rect.size)
          assert(selection_rect.size.x >= 0 and selection_rect.size.y >= 0)
          selection_box.visible = false
          select_objects()
    
    if Input.is_action_just_pressed("exit") and is_selecting:
      is_selecting = false
      selection_box.visible = false
    # in the future >>>
    # if Input.is_action_just_pressed("exit") and not is_selecting:
    #   exit to main menu

func select_objects():
  # get all the nodes that need to be selected
  var selected_objects: Array[Selectable] = []
  var selectable_objects = get_tree().get_nodes_in_group("Selectable")
  for selectable_object: Selectable in selectable_objects:
    if selectable_object.is_in_rect(selection_rect):
      selected_objects.append(selectable_object)
  if object_selected_context.is_active == false:
    self.game_context_manager.current_context = object_selected_context
  object_selected_context.set_selected_objects(selected_objects)
