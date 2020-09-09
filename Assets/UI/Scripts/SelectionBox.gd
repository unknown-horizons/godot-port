extends Control

var sel_pos_start = Vector3() # first click position

export(Color) var line_color = Color(1, 1, 1)
export(int) var line_width = 1

func _draw() -> void:
	if is_visible():
		var m_pos = get_viewport().get_mouse_position()
		var top_left: Vector2 = get_viewport().get_camera().unproject_position(sel_pos_start)
		if top_left != m_pos:
			draw_line(top_left, Vector2(m_pos.x, top_left.y), line_color, line_width) # upper right
			draw_line(top_left, Vector2(top_left.x, m_pos.y), line_color, line_width) # lower left
			draw_line(m_pos, Vector2(m_pos.x, top_left.y), line_color, line_width) # upper left
			draw_line(m_pos, Vector2(top_left.x, m_pos.y), line_color, line_width) # lower right

func _process(_delta: float) -> void:
	update()

func set_sel_pos_start(tl: Vector3) -> void:
	sel_pos_start = tl
