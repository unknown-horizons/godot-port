extends WidgetButton
class_name ZoomButton

enum ZOOM_DIRECTION {IN, OUT}
@export var zoom_direction: ZOOM_DIRECTION

func _ready() -> void:
	pressed.connect(_on_ZoomButton_pressed)

	if zoom_direction == ZOOM_DIRECTION.IN:
		Global.camera_max_zoom.connect(_on_camera_min_max_zoom)
	elif zoom_direction == ZOOM_DIRECTION.OUT:
		Global.camera_min_zoom.connect(_on_camera_min_max_zoom)

func _on_camera_min_max_zoom(is_limit_reached: bool):
	disabled = is_limit_reached

func _on_ZoomButton_pressed() -> void:
	if zoom_direction == ZOOM_DIRECTION.IN:
		Global.emit_signal("camera_zoom_in")
	elif zoom_direction == ZOOM_DIRECTION.OUT:
		Global.emit_signal("camera_zoom_out")
