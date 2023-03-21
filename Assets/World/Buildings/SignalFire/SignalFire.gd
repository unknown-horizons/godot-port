@tool
extends Building
class_name SignalFire

# Tiers
const SIGNAL_FIRE = "res://Assets/World/Buildings/SignalFire/SignalFire.tscn"
const SIGNAL_FIRE_WOODEN = "res://Assets/World/Buildings/SignalFire/SignalFire.tscn"

# Tier 1 (Sailors) Resources
const SIGNAL_FIRE_IDLE_45 = preload("res://Assets/World/Buildings/SignalFire/Sprites/SignalFire_idle_45.png")
const SIGNAL_FIRE_IDLE_135 = preload("res://Assets/World/Buildings/SignalFire/Sprites/SignalFire_idle_135.png")
const SIGNAL_FIRE_IDLE_315 = preload("res://Assets/World/Buildings/SignalFire/Sprites/SignalFire_idle_225.png")
const SIGNAL_FIRE_IDLE_225 = preload("res://Assets/World/Buildings/SignalFire/Sprites/SignalFire_idle_315.png")

# Tier 2 (Pioneers) Resources
const SIGNAL_FIRE_WOODEN_IDLE_45 = preload("res://Assets/World/Buildings/SignalFire/Sprites/SignalFireWooden_idle_45.png")
const SIGNAL_FIRE_WOODEN_IDLE_135 = preload("res://Assets/World/Buildings/SignalFire/Sprites/SignalFireWooden_idle_135.png")
const SIGNAL_FIRE_WOODEN_IDLE_315 = preload("res://Assets/World/Buildings/SignalFire/Sprites/SignalFireWooden_idle_225.png")
const SIGNAL_FIRE_WOODEN_IDLE_225 = preload("res://Assets/World/Buildings/SignalFire/Sprites/SignalFireWooden_idle_315.png")

# Tier 3 (Settlers) Resources
const SIGNAL_FIRE_CLINKER_IDLE_45 = preload("res://Assets/World/Buildings/SignalFire/Sprites/SignalFireClinker_idle_45.png")
const SIGNAL_FIRE_CLINKER_IDLE_135 = preload("res://Assets/World/Buildings/SignalFire/Sprites/SignalFireClinker_idle_135.png")
const SIGNAL_FIRE_CLINKER_IDLE_315 = preload("res://Assets/World/Buildings/SignalFire/Sprites/SignalFireClinker_idle_225.png")
const SIGNAL_FIRE_CLINKER_IDLE_225 = preload("res://Assets/World/Buildings/SignalFire/Sprites/SignalFireClinker_idle_315.png")

# Tier 1 (Sailors) Sprites
const SIGNAL_FIRE_IDLE_ANIM = [
	SIGNAL_FIRE_IDLE_45,
	SIGNAL_FIRE_IDLE_135,
	SIGNAL_FIRE_IDLE_225,
	SIGNAL_FIRE_IDLE_315,
]

# Tier 2 (Pioneers) Sprites
const SIGNAL_FIRE_WOODEN_IDLE_ANIM = [
	SIGNAL_FIRE_WOODEN_IDLE_45,
	SIGNAL_FIRE_WOODEN_IDLE_135,
	SIGNAL_FIRE_WOODEN_IDLE_225,
	SIGNAL_FIRE_WOODEN_IDLE_315,
]

# Tier 3 (Settlers) Sprites
const SIGNAL_FIRE_CLINKER_IDLE_ANIM = [
	SIGNAL_FIRE_CLINKER_IDLE_45,
	SIGNAL_FIRE_CLINKER_IDLE_135,
	SIGNAL_FIRE_CLINKER_IDLE_225,
	SIGNAL_FIRE_CLINKER_IDLE_315,
]

const TIERS = [
	SIGNAL_FIRE_IDLE_ANIM,
	SIGNAL_FIRE_WOODEN_IDLE_ANIM,
	SIGNAL_FIRE_CLINKER_IDLE_ANIM,
]

@export_range(0, 4) var tier: int : set = set_tier

func _ready() -> void:
	super()

	action = "idle"

func animate() -> void:
	match action:
		"idle":
			current_anim = TIERS[tier]
			self.texture = TIERS[tier][rotation_offset]

			match tier:
				0:
					_billboard.vframes = 2
					_billboard.hframes = 5
					_billboard.region_rect = Rect2(0, 0, 320, 256)
					_billboard.region_enabled = true
				1:
					_billboard.vframes = 4
					_billboard.hframes = 4
					_billboard.region_rect = Rect2(0, 0, 256, 512)
					_billboard.region_enabled = true
				2:
					_billboard.vframes = 4
					_billboard.hframes = 4
					_billboard.region_rect = Rect2(0, 0, 256, 512)
					_billboard.region_enabled = true

			_billboard.frame = next_frame()

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
