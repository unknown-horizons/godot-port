@tool
extends Building
class_name Chapel

# Tier 1 (Sailors) Resources
const CHAPEL_IDLE = preload("res://Assets/World/Buildings/Chapel/Sprites/SunSail_idle.png")

# Tier 2 (Pioneers) Resources
const CHAPEL_WOODEN_IDLE = preload("res://Assets/World/Buildings/Chapel/Sprites/Chapel_idle.png")

# Tier 3 (Settlers) Resources
const CHAPEL_CLINKER_IDLE = preload("res://Assets/World/Buildings/Chapel/Sprites/ChapelClinker_idle.png")

const TIERS = [
	CHAPEL_IDLE,
	CHAPEL_WOODEN_IDLE,
	CHAPEL_CLINKER_IDLE,
]

@export_range(0, 4) var tier: int : set = set_tier

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = TIERS[tier]
			match tier:
				0:
					_billboard.vframes = 2
					_billboard.hframes = 2
					_billboard.region_rect = Rect2(0, 0, 256, 256)
					_billboard.region_enabled = true
					_billboard.offset = Vector2(0, 32)
				1, 2:
					_billboard.vframes = 2
					_billboard.hframes = 2
					_billboard.region_rect = Rect2(0, 0, 256, 256)
					_billboard.region_enabled = true
					_billboard.offset = Vector2(0, 48)

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
