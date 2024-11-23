extends Camera2D

@export var move_sensitivity: float = 5
@export var zoom_sensitivity: float = 1

var should_move_camera = false



func _unhandled_input(event):
  check_and_move_camera(event)
  check_and_zoom_camera(event)



func check_and_move_camera(event):
  if event is InputEventMouseButton:
    if event.pressed and event.button_index == MOUSE_BUTTON_MIDDLE:
      should_move_camera = true
  
    if not event.pressed:
      should_move_camera = false

  if event is InputEventMouseMotion and should_move_camera:
    self.position += - event.screen_relative * move_sensitivity



func check_and_zoom_camera(event):
  if event is InputEventMouseButton:
    if event.pressed == true:

      if event.button_index == MOUSE_BUTTON_WHEEL_UP and self.zoom < Vector2(2, 2):
        self.zoom += self.zoom * Vector2(zoom_sensitivity, zoom_sensitivity)

      if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and self.zoom > Vector2(0.2, 0.2):
        self.zoom -= self.zoom / Vector2(zoom_sensitivity, zoom_sensitivity) / 2
