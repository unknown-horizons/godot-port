extends Spatial

var rotationY # : Spatial
var camera # : Camera

func _ready():
	rotationY = get_child(0)
	camera = rotationY.get_child(0)
	recalculate_directions()

func _process(delta):
	# Camera movement.
	var movement_scale = delta * 10
	if Input.is_action_pressed("move_faster"):
		movement_scale *= 3
	
	# Not elif because movement should cancel out if both are pressed
	if Input.is_action_pressed("move_up"):
		translate(directions[0] * movement_scale * 1.2)
	if Input.is_action_pressed("move_down"):
		translate(directions[1] * movement_scale * 1.2)
	if Input.is_action_pressed("move_left"):
		translate(directions[2] * movement_scale)
	if Input.is_action_pressed("move_right"):
		translate(directions[3] * movement_scale)

func _input(event):
	# Camera rotation.
	if event.is_action_pressed("rotate_left"):
		rotationY.rotate_y(-1.57079632679)
		recalculate_directions()
	elif event.is_action_pressed("rotate_right"):
		rotationY.rotate_y(1.57079632679)
		recalculate_directions()
	
	# Camera zooming.
	elif event.is_action_pressed("zoom_in"):
		if camera.size > 5:
			camera.size -= 5
	elif event.is_action_pressed("zoom_out"):
		if camera.size < 35:
			camera.size += 5

var directions = [Vector3(), Vector3(), Vector3(), Vector3()] # : PoolVector3Array ?

func recalculate_directions():
	# We could always hard-code the directions, but this is better.
	var basis = rotationY.get_transform().basis
	directions[0] = -basis.z
	directions[1] = basis.z
	directions[2] = -basis.x
	directions[3] = basis.x
