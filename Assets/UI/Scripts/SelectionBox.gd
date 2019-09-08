extends Control

var is_visible = false
var m_pos = Vector2()
var start_sel_pos = Vector2() # first click position

const sel_box_col = Color(1, 1, 1)
const sel_box_line_width = 1

func _draw() -> void:
	if is_visible and start_sel_pos != m_pos:
		draw_line(start_sel_pos, Vector2(m_pos.x, start_sel_pos.y), sel_box_col, sel_box_line_width) # upper right
		draw_line(start_sel_pos, Vector2(start_sel_pos.x, m_pos.y), sel_box_col, sel_box_line_width) # lower left
		draw_line(m_pos, Vector2(m_pos.x, start_sel_pos.y), sel_box_col, sel_box_line_width) # upper left
		draw_line(m_pos, Vector2(start_sel_pos.x, m_pos.y), sel_box_col, sel_box_line_width) # lower right

func _process(_delta: float) -> void:
	update()
