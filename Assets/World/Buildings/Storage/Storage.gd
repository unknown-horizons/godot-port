@tool
extends Building
class_name Storage

# Tier 1 (Sailors) Resources
const STORAGE_TENT_IDLE = preload("res://Assets/World/Buildings/Storage/Sprites/StorageTent_idle.png")

# Tier 2 (Pioneers) Resources
const STORAGE_HUT_IDLE = preload("res://Assets/World/Buildings/Storage/Sprites/StorageHut_idle.png")

const TIERS = [
	STORAGE_TENT_IDLE,
	STORAGE_HUT_IDLE,
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
					_billboard.region_rect = Rect2(0, 0, 256, 192)
					_billboard.region_enabled = true
					_billboard.offset = Vector2(0, 16)
				1:
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
