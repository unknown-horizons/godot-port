@tool
extends Building
class_name Lumberjack

# Tiers
const LUMBERJACK_TENT = "res://Assets/World/Buildings/Lumberjack/Lumberjack.tscn"
const LUMBERJACK_HUT = "res://Assets/World/Buildings/Lumberjack/Lumberjack.tscn"

# Tier 1 (Sailors) Resources
const LUMBERJACK_TENT_IDLE = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackTent_idle.png")
const LUMBERJACK_TENT_IDLE_LOGS_01 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackTent_idle_logs_01.png")
const LUMBERJACK_TENT_IDLE_LOGS_02 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackTent_idle_logs_02.png")
const LUMBERJACK_TENT_IDLE_LOGS_03 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackTent_idle_logs_03.png")
const LUMBERJACK_TENT_IDLE_LOGS_04 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackTent_idle_logs_04.png")
const LUMBERJACK_TENT_IDLE_LOGS_05 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackTent_idle_logs_05.png")

# Tier 2 (Pioneers) Resources
const LUMBERJACK_HUT_IDLE = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_idle.png")
const LUMBERJACK_HUT_IDLE_LOGS_01 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_logs_01.png")
const LUMBERJACK_HUT_IDLE_LOGS_02 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_logs_02.png")
const LUMBERJACK_HUT_IDLE_LOGS_03 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_logs_03.png")
const LUMBERJACK_HUT_IDLE_LOGS_04 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_logs_04.png")
const LUMBERJACK_HUT_IDLE_LOGS_05 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_logs_05.png")

const LUMBERJACK_HUT_IDLE_PLANKS_01 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_planks_01.png")
const LUMBERJACK_HUT_IDLE_PLANKS_02 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_planks_02.png")
const LUMBERJACK_HUT_IDLE_PLANKS_03 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_planks_03.png")
const LUMBERJACK_HUT_IDLE_PLANKS_04 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_planks_04.png")
const LUMBERJACK_HUT_IDLE_PLANKS_05 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_planks_05.png")
const LUMBERJACK_HUT_IDLE_PLANKS_06 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_planks_06.png")
const LUMBERJACK_HUT_IDLE_PLANKS_07 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_planks_07.png")
const LUMBERJACK_HUT_IDLE_PLANKS_08 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_planks_08.png")
const LUMBERJACK_HUT_IDLE_PLANKS_09 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_planks_09.png")
const LUMBERJACK_HUT_IDLE_PLANKS_10 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_planks_10.png")
const LUMBERJACK_HUT_IDLE_PLANKS_11 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_planks_11.png")
const LUMBERJACK_HUT_IDLE_PLANKS_12 = preload("res://Assets/World/Buildings/Lumberjack/Sprites/LumberjackHut_overlay_planks_12.png")

# Tier 1 (Sailors) Sprites
const LUMBERJACK_TENT_IDLE_LOGS = [
	LUMBERJACK_TENT_IDLE,
	LUMBERJACK_TENT_IDLE_LOGS_01,
	LUMBERJACK_TENT_IDLE_LOGS_02,
	LUMBERJACK_TENT_IDLE_LOGS_03,
	LUMBERJACK_TENT_IDLE_LOGS_04,
	LUMBERJACK_TENT_IDLE_LOGS_05,
]

#const LUMBERJACK_TENT_WORK_ANIM = [
#	LUMBERJACK_TENT_WORK_45,
#	LUMBERJACK_TENT_WORK_135,
#	LUMBERJACK_TENT_WORK_225,
#	LUMBERJACK_TENT_WORK_315,
#]

#const LUMBERJACK_TENT_BURN_ANIM = [
#	LUMBERJACK_TENT_BURN_45,
#	LUMBERJACK_TENT_BURN_135,
#	LUMBERJACK_TENT_BURN_225,
#	LUMBERJACK_TENT_BURN_315,
#]

# Tier 2 (Pioneers) Sprites Logs
const LUMBERJACK_HUT_IDLE_LOGS = [
	LUMBERJACK_HUT_IDLE_LOGS_01,
	LUMBERJACK_HUT_IDLE_LOGS_02,
	LUMBERJACK_HUT_IDLE_LOGS_03,
	LUMBERJACK_HUT_IDLE_LOGS_04,
	LUMBERJACK_HUT_IDLE_LOGS_05,
]

# Tier 2 (Pioneers) Sprites Planks
const LUMBERJACK_HUT_IDLE_PLANKS = [
	LUMBERJACK_HUT_IDLE_PLANKS_01,
	LUMBERJACK_HUT_IDLE_PLANKS_02,
	LUMBERJACK_HUT_IDLE_PLANKS_03,
	LUMBERJACK_HUT_IDLE_PLANKS_04,
	LUMBERJACK_HUT_IDLE_PLANKS_05,
	LUMBERJACK_HUT_IDLE_PLANKS_06,
	LUMBERJACK_HUT_IDLE_PLANKS_07,
	LUMBERJACK_HUT_IDLE_PLANKS_08,
	LUMBERJACK_HUT_IDLE_PLANKS_09,
	LUMBERJACK_HUT_IDLE_PLANKS_10,
	LUMBERJACK_HUT_IDLE_PLANKS_11,
	LUMBERJACK_HUT_IDLE_PLANKS_12,
]

const TIERS = [
	LUMBERJACK_TENT_IDLE,
	LUMBERJACK_HUT_IDLE,
]

@export var tier: int : set = set_tier # (int, 0, 4)
@export var resource_amount := 0 : set = set_resource_amount # (int, 0, 5)
@export var resource_amount_output := 0 : set = set_resource_amount_output # (int, 0, 12)

@onready var resource_overlay := get_node_or_null("Billboard/ResourceOverlay")
@onready var resource_overlay2 := get_node_or_null("Billboard/ResourceOverlay2")

func _ready() -> void:
	super()
	set_rotation_degree(rotation_degree)
	set_resource_amount(resource_amount)
	set_resource_amount_output(resource_amount_output)

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			match tier:
				0:
					self.texture = TIERS[0] if not texture in LUMBERJACK_TENT_IDLE_LOGS else texture
					_billboard.vframes = 2
					_billboard.hframes = 2
					_billboard.region_rect = Rect2(0, 0, 256, 256)
					_billboard.region_enabled = true
					_billboard.offset = Vector2(0, 32)
				1:
					self.texture = TIERS[tier]
					_billboard.vframes = 2
					_billboard.hframes = 2
					_billboard.region_rect = Rect2(0, 0, 256, 256)
					_billboard.region_enabled = true
					_billboard.offset = Vector2(0, 32)

	super()

func set_tier(new_tier: int) -> void:
	var previous_tier = tier

	tier = clamp(new_tier, 0, TIERS.size() - 1)
	if tier > previous_tier:
		upgrade()
	else:
		downgrade()

func upgrade() -> void:
	pass # TODO

func downgrade() -> void:
	pass # TODO

func set_resource_amount(new_resource_amount: int) -> void:
	resource_amount = new_resource_amount

	if not is_inside_tree():
		return

	if tier == 0:
		self.texture = LUMBERJACK_TENT_IDLE_LOGS[resource_amount]
	else:
		self.texture = LUMBERJACK_HUT_IDLE
		resource_overlay.texture = LUMBERJACK_HUT_IDLE_LOGS[clamp(resource_amount - 1, 0, LUMBERJACK_HUT_IDLE_LOGS.size() - 1)] if resource_amount > 0 else null

func set_resource_amount_output(new_resource_amount_output) -> void:
	resource_amount_output = new_resource_amount_output

	if not is_inside_tree():
		return

	if tier == 1:
		self.texture = LUMBERJACK_HUT_IDLE
		resource_overlay2.texture = LUMBERJACK_HUT_IDLE_PLANKS[clamp(resource_amount_output - 1, 0, LUMBERJACK_HUT_IDLE_PLANKS.size() - 1)] if resource_amount_output > 0 else null

func add_resource() -> void:
	pass # TODO

func remove_resource() -> void:
	pass # TODO

func _on_input(event: InputEvent):
	super(event)

	if null in [resource_overlay, resource_overlay2]: return

	# Switch frame accordingly with the world rotation.
	if event.is_action_pressed("rotate_left"):
		resource_overlay.frame = wrapi(resource_overlay.frame - 1, 0,
				resource_overlay.hframes * resource_overlay.vframes)
		resource_overlay2.frame = wrapi(resource_overlay2.frame - 1, 0,
				resource_overlay2.hframes * resource_overlay2.vframes)
	elif event.is_action_pressed("rotate_right"):
		resource_overlay.frame = wrapi(resource_overlay.frame + 1, 0,
				resource_overlay.hframes * resource_overlay.vframes)
		resource_overlay2.frame = wrapi(resource_overlay2.frame + 1, 0,
				resource_overlay2.hframes * resource_overlay2.vframes)

func set_rotation_degree(new_rotation: int) -> void:
	super(new_rotation)

	if not is_inside_tree() or resource_overlay == null:
		return

	resource_overlay.frame = self.rotation_index
	resource_overlay2.frame = self.rotation_index
