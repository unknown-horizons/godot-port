tool
extends WorldThing
class_name Building

var current_anim # if not null, action can be animated, otherwise static
var previous_anim

var rotation_index setget ,get_rotation_index
var rotation_offset := 0

onready var timer := Timer.new() # to play an animation in a sane speed

export(String) var action := "idle" setget set_action
export(float, 0, 1) var anim_speed := 0.95 setget set_anim_speed

func _ready():
	add_child(timer)
	# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start(1.001 - anim_speed)

	add_to_group("billboard")

#func update_offset(new_rotation):
#	var new_offset = Vector2()
#	match int(round(new_rotation)):
#		-45:
#			new_offset = Vector2(x1, y1)
#		45:
#			new_offset = Vector2(x2, y2)
#		135:
#			new_offset = Vector2(x3, x3)
#		-135:
#			new_offset = Vector2(x4, x4)
#
#	#print("Update offset for {0}: {1}".format([self.name, new_offset]))
#	_billboard.offset = new_offset

func animate() -> void: # to be overridden
	if previous_anim != current_anim and current_anim == null:
		_billboard.frame = self.rotation_index

	previous_anim = current_anim

func _on_input(event: InputEvent) -> void:
	if current_anim == null:
		._on_input(event)
		return

	# Switch texture accordingly with the world rotation.
	if event.is_action_pressed("rotate_left"):
		rotation_offset = wrapi(rotation_offset - 1, 0, 4)
		if typeof(current_anim) == TYPE_ARRAY:
			self.texture = current_anim[self.rotation_index]
		else: # HACK
			_billboard.frame = wrapi(_billboard.frame - 1, 0, _billboard.vframes * _billboard.hframes)
			animate()
	elif event.is_action_pressed("rotate_right"):
		rotation_offset = wrapi(rotation_offset + 1, 0, 4)
		if typeof(current_anim) == TYPE_ARRAY:
			self.texture = current_anim[self.rotation_index]
		else: # HACK
			_billboard.frame = wrapi(_billboard.frame - 1, 0, _billboard.vframes * _billboard.hframes)
			animate()

# Return the object's rotation with current camera rotation taken into account
func get_rotation_index() -> int:
	# warning-ignore:shadowed_variable
	var rotation_index

	match rotation_degree:
		RotationDegree.ZERO:
			rotation_index = 0
		RotationDegree.NINETY:
			rotation_index = 1
		RotationDegree.ONE_EIGHTY:
			rotation_index = 2
		RotationDegree.TWO_SEVENTY:
			rotation_index = 3

	# Explanation:
	# rotation_degree	-> WorldThing rotation (8 rotations (0 - 7))
	# rotation_index	-> Building rotation (4 rotations (0 - 3))
	# rotation_offset	-> Camera rotation offset relative to Building rotation
	#
	# Returned rotation_index is rotation_index + rotation_offset
	#	=> actual/current rotation

	#prints("rotation_degree:", rotation_degree)
	#prints("rotation_index:", rotation_index)
	#prints("rotation_offset:", rotation_offset)

	return (rotation_index + rotation_offset) % 4

func set_action(new_action) -> void:
	action = new_action

func set_anim_speed(new_anim_speed) -> void:
	anim_speed = new_anim_speed

	if timer == null: return
	if anim_speed > 0:
		timer.wait_time = 1.001 - anim_speed
		if timer.is_stopped():# and current_anim != null:
			timer.start()
	else:
		timer.stop()

func _on_Timer_timeout() -> void:
#	if Engine.is_editor_hint():
#		if _billboard == null:
#			if not Global._warning:
#				prints("Please reload the scene [{0}].".format([name]))
#				Global._warning = true
#			timer.stop() # The timer does not stop. Why?
#			return

	animate()
