extends WidgetButton
class_name ZoomButton

enum ZOOM_DIRECTION {IN, OUT}
@export var zoom_direction: ZOOM_DIRECTION

func _ready() -> void:
	pressed.connect(Callable(self, "_on_ZoomButton_pressed"))

	if zoom_direction == ZOOM_DIRECTION.IN:
		Global.camera_max_zoom.connect(Callable(self, "_on_camera_min_max_zoom"))
	elif zoom_direction == ZOOM_DIRECTION.OUT:
		Global.camera_min_zoom.connect(Callable(self, "_on_camera_min_max_zoom"))

func _on_camera_min_max_zoom(value: bool):
	disabled = value

func _on_ZoomButton_pressed():
	if zoom_direction == ZOOM_DIRECTION.IN:
		Global.emit_signal("camera_zoom_in")
	elif zoom_direction == ZOOM_DIRECTION.OUT:
		Global.emit_signal("camera_zoom_out")
