extends Camera2D

@export var zoom_sensitivity: float = 0.5
@export var zoom_duration := 0.2

var should_move_camera = false

# touch control vars:
var dragging := false
var last_drag_pos := Vector2.ZERO

# For pinch zoom
var active_touches: Dictionary[int, Vector2]= {}  # Dictionary: touch_index -> position
var last_pinch_dist := 0.0

func set_zoom_smooth(new_zoom: float):
	var tween = self.get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(new_zoom, new_zoom), zoom_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)

func _unhandled_input(event):
	#print(event)
	var mouse_motion_event := event as InputEventMouseMotion
	if mouse_motion_event != null:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			self.position += -mouse_motion_event.relative / self.zoom.x

	var mouse_button_event := event as InputEventMouseButton
	if mouse_button_event != null and mouse_button_event.pressed:
		if mouse_button_event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if self.zoom.x < 2:
				set_zoom_smooth(self.zoom.x +  zoom_sensitivity * self.zoom.x)
		if mouse_button_event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if self.zoom.x > 0.2:
				set_zoom_smooth(self.zoom.x -  zoom_sensitivity * self.zoom.x)

	# --- Touch Input ---
	var screen_touch_event = event as InputEventScreenTouch
	if screen_touch_event != null:
		#print(screen_touch_event)
		if screen_touch_event.pressed:
			active_touches[screen_touch_event.index] = screen_touch_event.position
		else:
			# TODO: add correct pinch logic for touch devices
			active_touches.erase(screen_touch_event.index)
			if active_touches.size() < 2:
				last_pinch_dist = 0.0

	var screen_drag_event = event as InputEventScreenDrag
	if screen_drag_event != null:
		#print(screen_drag_event)
		active_touches[screen_drag_event.index] = screen_drag_event.position

		# One finger → drag camera
		if active_touches.size() == 1:
			# var touch_pos = active_touches.values()[0]
			var delta = screen_drag_event.relative
			position -= delta / zoom.x

		# Two fingers → pinch zoom
		elif active_touches.size() == 2:
			var dist = active_touches[0].distance_to(active_touches[1])

			if last_pinch_dist != 0.0:
				var zoom_factor = dist / last_pinch_dist
				var new_zoom = clamp(zoom.x / zoom_factor, 0.2, 2)
				set_zoom_smooth(new_zoom)

			last_pinch_dist = dist


func get_pinch_distance(screen_drag_event: InputEventScreenDrag) -> float:
	if screen_drag_event.index < 2:
		return 0.0
	var p1 = screen_drag_event.position
	var p2 = screen_drag_event.position
	return p1.distance_to(p2)
