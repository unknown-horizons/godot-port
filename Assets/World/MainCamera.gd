extends Camera2D

@export var zoom_sensitivity: float = 0.5
@export var zoom_duration := 0.2

var should_move_camera = false

func set_zoom_smooth(new_zoom: float):
  var tween = self.get_tree().create_tween()
  tween.tween_property(self, "zoom", Vector2(new_zoom, new_zoom), zoom_duration) \
    .set_trans(Tween.TRANS_SINE) \
    .set_ease(Tween.EASE_OUT)

func _unhandled_input(event):
  if event is InputEventMouseMotion:
    if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
      self.position += -event.relative / self.zoom.x

  if event is InputEventMouseButton and event.pressed:
    if event.button_index == MOUSE_BUTTON_WHEEL_UP:
      if self.zoom.x < 2:
        set_zoom_smooth(self.zoom.x +  zoom_sensitivity * self.zoom.x)
    if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
      if self.zoom.x > 0.2:
        set_zoom_smooth(self.zoom.x -  zoom_sensitivity * self.zoom.x)
