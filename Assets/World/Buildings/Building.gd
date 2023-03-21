@tool
extends WorldThing
class_name Building

## Base class for all buildings.

## If not null, action can be animated, otherwise static.
var current_anim
var previous_anim

## Returns the object's rotation with the current camera rotation taken into account.
var rotation_index : get = get_rotation_index
var rotation_offset := 0

## To play an animation in a sane speed.
@onready var timer := Timer.new()

@export var action := "idle" : set = set_action
@export var anim_speed := 0.95 : set = set_anim_speed # (float, 0, 1)

@export var debug_animate := false

func _ready():
	super()
	add_child(timer)
	timer.timeout.connect(Callable(self, "_on_Timer_timeout"))
	timer.start(1.001 - anim_speed)

func _process(_delta: float) -> void:
	super(_delta)
	if Engine.is_editor_hint():
		if not debug_animate and current_anim != null:
			_billboard.frame = 0
			return
	else:
		set_process(false)

#func set_faction(new_faction: int) -> void:
#	faction = new_faction

func select() -> void:
	prints("SELECT", self)
	Audio.play_snd_click()
	# TODO: Highlighting effect
	_billboard.modulate = Color.GOLD

func deselect() -> void:
	prints("DESELECT", self)
	_billboard.modulate = Color.WHITE

func animate() -> void: # to be overridden
	if previous_anim != current_anim and current_anim == null:
		_billboard.frame = self.rotation_index

	previous_anim = current_anim

func _on_input(event: InputEvent) -> void:
	if current_anim == null:
		super(event)
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

func get_rotation_index() -> int:
	# warning-ignore:shadowed_variable
	var rotation_degree_per_90

	match rotation_degree:
		RotationDegree.ZERO:
			rotation_degree_per_90 = 0
		RotationDegree.NINETY:
			rotation_degree_per_90 = 1
		RotationDegree.ONE_EIGHTY:
			rotation_degree_per_90 = 2
		RotationDegree.TWO_SEVENTY:
			rotation_degree_per_90 = 3

	# Explanation:
	# rotation_degree			-> WorldThing rotation (8 rotations (0 - 7))
	# rotation_degree_per_90	-> Building rotation (4 rotations (0 - 3))
	# rotation_offset			-> Camera rotation offset relative to Building rotation
	#
	# Returned rotation_index is (rotation_degree_per_90 + rotation_offset) % 4
	#	=> actual/current rotation

	#prints("rotation_degree:", rotation_degree)
	#prints("rotation_degree_per_90:", rotation_degree_per_90)
	#prints("rotation_offset:", rotation_offset)

	return (rotation_degree_per_90 + rotation_offset) % 4

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
	if _billboard == null:
		return

#	if Engine.is_editor_hint():
#		if not Global._warning:
#			prints("Please reload the scene [{0}].".format([name]))
#			Global._warning = true
#		timer.stop() # The timer does not stop. Why?
#		return

	animate()
