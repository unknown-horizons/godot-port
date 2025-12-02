extends Control

class_name SelectionBox

var sel_pos_start := Vector2(0,0) # first click position

@export var line_color: Color = Color(1, 1, 1, 0.5)

func _unhandled_input(event):
  var mouseButtonEvent := event as InputEventMouseButton
  if mouseButtonEvent != null:
    if mouseButtonEvent.button_index == MOUSE_BUTTON_LEFT:
      if mouseButtonEvent.pressed:
        sel_pos_start = get_viewport().get_mouse_position()

func _process(_delta: float) -> void:
  queue_redraw()

func _draw() -> void:
  if is_visible():
    var m_pos := get_viewport().get_mouse_position()
    if sel_pos_start != m_pos:
      # the wimdow size is (1920, 1080) and the user might have resized the window
      draw_line(sel_pos_start, Vector2(m_pos.x, sel_pos_start.y), line_color, -1) # m_pos x
      draw_line(sel_pos_start, Vector2(sel_pos_start.x, m_pos.y), line_color, -1) # m_pos y
      draw_line(m_pos, Vector2(m_pos.x, sel_pos_start.y), line_color, -1) # sel_pos_start y
      draw_line(m_pos, Vector2(sel_pos_start.x, m_pos.y), line_color, -1) # sel_pos_start x
