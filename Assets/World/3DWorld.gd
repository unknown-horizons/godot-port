extends Spatial

func _input(event):
	# Camera controls.
	if event.is_action_pressed("ui_left"):
		$CameraCenter.rotation_degrees.y -= 90
	elif event.is_action_pressed("ui_right"):
		$CameraCenter.rotation_degrees.y += 90
	elif event.is_action_pressed("ui_up"):
		var camera = $CameraCenter/Camera
		if camera.size > 5:
			camera.size -= 5
	elif event.is_action_pressed("ui_down"):
		var camera = $CameraCenter/Camera
		if camera.size < 35:
			camera.size += 5
