@tool
extends Ship
class_name Pirate

const PIRATE_IDLE_ANIM = preload("res://Assets/World/Units/Ships/Pirates/Pirate/Sprites/Pirate_idle.png")

const PIRATE_BLACK_MOVE_0 = preload("res://Assets/World/Units/Ships/Pirates/Pirate/Sprites/PirateBlack_move_0.png")
const PIRATE_BLACK_MOVE_45 = preload("res://Assets/World/Units/Ships/Pirates/Pirate/Sprites/PirateBlack_move_45.png")
const PIRATE_BLACK_MOVE_90 = preload("res://Assets/World/Units/Ships/Pirates/Pirate/Sprites/PirateBlack_move_90.png")
const PIRATE_BLACK_MOVE_135 = preload("res://Assets/World/Units/Ships/Pirates/Pirate/Sprites/PirateBlack_move_135.png")
const PIRATE_BLACK_MOVE_180 = preload("res://Assets/World/Units/Ships/Pirates/Pirate/Sprites/PirateBlack_move_180.png")
const PIRATE_BLACK_MOVE_225 = preload("res://Assets/World/Units/Ships/Pirates/Pirate/Sprites/PirateBlack_move_225.png")
const PIRATE_BLACK_MOVE_270 = preload("res://Assets/World/Units/Ships/Pirates/Pirate/Sprites/PirateBlack_move_270.png")
const PIRATE_BLACK_MOVE_315 = preload("res://Assets/World/Units/Ships/Pirates/Pirate/Sprites/PirateBlack_move_315.png")

const PIRATE_MOVE_ANIM = [
	PIRATE_BLACK_MOVE_0,
	PIRATE_BLACK_MOVE_45,
	PIRATE_BLACK_MOVE_90,
	PIRATE_BLACK_MOVE_135,
	PIRATE_BLACK_MOVE_180,
	PIRATE_BLACK_MOVE_225,
	PIRATE_BLACK_MOVE_270,
	PIRATE_BLACK_MOVE_315,
]

@export var debug_is_moving: bool = is_moving

var current_anim_position := 0.0
var last_anim = "fade_out"

@onready var _reflection: Sprite3D = $Reflection as Sprite3D
@onready var water_overlay: Node3D = $WaterOverlay as Node3D
@onready var water_overlay1: Sprite3D = $WaterOverlay/WaterOverlay1 as Sprite3D
@onready var water_overlay2: Sprite3D = $WaterOverlay/WaterOverlay2 as Sprite3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer

# Static (for now)
@onready var patrol_route = [
	Vector2(-30,  30),
	Vector2( 39,  40),
	Vector2( 39, -38),
	Vector2(-35, -38)
]
var next_patrol_index = -1

func _ready() -> void:
	if not Engine.is_editor_hint():
		debug_is_moving = false

func _process(_delta: float):
	patrol() # DEBUG

	# TODO: Water reflection (in animate_movement())
	# 		and WaterOverlay effect
	#animate_water_overlay()

func patrol():
	if Engine.is_editor_hint():
		return

#	prints("pirate:",
#		int(round(global_transform.origin.x)),
#		int(round(global_transform.origin.y))
#	)
#
#	prints("patrol_route",
#		int(round(patrol_route[next_patrol_index].x)),
#		int(round(patrol_route[next_patrol_index].y))
#	)
	if path.size() == 0:
		next_patrol_index += 1
		if next_patrol_index >= patrol_route.size():
			next_patrol_index = 0
		move_to(patrol_route[next_patrol_index])

func animate_movement():
	if is_moving or debug_is_moving:
		_billboard.vframes = 4
		_billboard.hframes = 4
		_billboard.region_rect = Rect2(0, 0, 896, 896)

		_reflection.vframes = 4
		_reflection.hframes = 4
		_reflection.region_rect = Rect2(0, 0, 896, 896)
		update_rotation()

		# For editor preview
		if Engine.is_editor_hint():
			rotation_index = rotation_degree

		self.texture = PIRATE_MOVE_ANIM[rotation_index]
		_reflection.texture = PIRATE_MOVE_ANIM[rotation_index]

		_billboard.frame = next_frame()

		if rotation_index == 1:
			_reflection.rotation_degrees = Vector3(0, 0, -60)
		elif rotation_index == 3:
			_reflection.rotation_degrees = Vector3(0, 0, 30)
		else:
			_reflection.rotation_degrees = Vector3(0, -45, 0)
		_reflection.frame = next_frame(_reflection)
	else:
		_billboard.vframes = 2
		_billboard.hframes = 4
		_billboard.region_rect = Rect2(0, 0, 896, 448)

		_reflection.region_rect = Rect2(0, 0, 896, 448)
		_reflection.vframes = 2
		_reflection.hframes = 4
		super.update_rotation()

		self.texture = PIRATE_IDLE_ANIM
		_reflection.texture = PIRATE_IDLE_ANIM

		# For editor preview
		if Engine.is_editor_hint():
			rotation_index = rotation_degree

		set_rotation_degree(wrapi(rotation_index, 0, _billboard.hframes * _billboard.vframes))

		if rotation_index == 1:
			_reflection.material_override.set("params_billboard_mode", StandardMaterial3D.BILLBOARD_DISABLED)
			_reflection.offset = Vector2(-4, -67)
			_reflection.rotation_degrees = Vector3(0, 0, -60)
		elif rotation_index == 3:
			_reflection.material_override.set("params_billboard_mode", StandardMaterial3D.BILLBOARD_DISABLED)
			_reflection.offset = Vector2(19, -81)
			_reflection.rotation_degrees = Vector3(-36, -110, 70)
		else:
			_reflection.material_override.set("params_billboard_mode", StandardMaterial3D.BILLBOARD_ENABLED)
			_reflection.offset = Vector2(0, -90)
			#_reflection.rotation_degrees = Vector3(0, -45, 0)
		_reflection.frame = (wrapi(rotation_index, 0, _billboard.hframes * _billboard.vframes))

# TODO: WaterOverlay fading transition effect
func animate_water_overlay() -> void:
	if animation_player.is_playing():
		current_anim_position = animation_player.current_animation_position

	if is_moving or debug_is_moving:
		water_overlay1.frame = wrapi(water_overlay1.frame + 1, 0, water_overlay1.vframes * water_overlay1.hframes)
		water_overlay2.frame = wrapi(water_overlay2.frame + 1, 0, water_overlay2.vframes * water_overlay2.hframes)

		match rotation_degree:
			RotationDegree.ZERO:
				update_water_overlay(water_overlay1, Vector3(0, -45, 0), Vector2(0, -90), false, true)
				update_water_overlay(water_overlay2, Vector3(0, -45, 0), Vector2(0, 16), false, false)
			RotationDegree.FORTY_FIVE:
				update_water_overlay(water_overlay1, Vector3(0, -90, 0), Vector2(0, -90), false, true)
				update_water_overlay(water_overlay2, Vector3(0, -90, 0), Vector2(0, 16), false, false)
			RotationDegree.NINETY:
				update_water_overlay(water_overlay1, Vector3(-90, -135, 0), Vector2(32, -45), false, true)
				update_water_overlay(water_overlay2, Vector3(-90, -135, 0), Vector2(32, 48), false, false)
			RotationDegree.ONE_THIRTY_FIVE:
				update_water_overlay(water_overlay1, Vector3(-90, -180, 0), Vector2(32, 90), false, false)
				update_water_overlay(water_overlay2, Vector3(-90, 0, 0), Vector2(-32, 16), true, false)
			RotationDegree.ONE_EIGHTY:
				update_water_overlay(water_overlay1, Vector3(-90, -225, 0), Vector2(0, 104), false, false)
				update_water_overlay(water_overlay2, Vector3(-90, -45, 0), Vector2(0, 0), true, false)
			RotationDegree.TWO_TWENTY_FIVE:
				update_water_overlay(water_overlay1, Vector3(-90, 90, 0), Vector2(-16, 90), false, false)
				update_water_overlay(water_overlay2, Vector3(-90, -90, 0), Vector2(16, 16), true, false)
			RotationDegree.TWO_SEVENTY:
				update_water_overlay(water_overlay1, Vector3(-90, 45, 0), Vector2(-32, 51), false, false)
				update_water_overlay(water_overlay2, Vector3(-90, -135, 0), Vector2(32, 48), true, false)
			RotationDegree.THREE_FIFTEEN:
				update_water_overlay(water_overlay1, Vector3(-90, 0, 0), Vector2(-32, -90), false, true)
				update_water_overlay(water_overlay2, Vector3(-90, 0, 0), Vector2(-32, 16), false, false)

		if not water_overlay.visible or animation_player.current_animation == "fade_out":
			water_overlay.visible = true
			animation_player.play("fade_in")
	else:
		if water_overlay.visible or animation_player.current_animation == "fade_in":
			animation_player.play("fade_out")

func update_water_overlay(
		water_overlay: Sprite3D,
		rotation: Vector3,
		offset: Vector2,
		flip_h: bool,
		flip_v: bool) -> void:
	water_overlay.rotation_degrees = rotation
	water_overlay.offset = offset
	water_overlay.flip_h = flip_h
	water_overlay.flip_v = flip_v

func update_rotation() -> void:
	rotation_index = wrapi(direction + rotation_offset, 0, PIRATE_MOVE_ANIM.size())

func _on_AnimationPlayer_animation_started(anim_name: String) -> void:
	if not is_inside_tree() or Engine.is_editor_hint():
		return

	if last_anim != animation_player.current_animation:
		animation_player.seek(current_anim_position) # FIXME: play_backwards()
#		prints("Last animation:", last_anim)
#		prints("Play animation:", animation_player.current_animation)
#		prints("Current position:", animation_player.current_animation_position)
	last_anim = anim_name

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	#prints("Animation finished:", anim_name)
	if anim_name == "fade_out" and not is_moving:
		water_overlay.visible = false
