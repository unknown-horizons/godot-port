@tool
extends Building
class_name Residence

# Tiers
const RESIDENTIAL_TENT = "res://Assets/World/Buildings/Residential/Residence.tscn"
const RESIDENTIAL_HUT = "res://Assets/World/Buildings/Residential/Residence.tscn"
const RESIDENTIAL_HOUSE_TIMBER_FRAMED = "res://Assets/World/Buildings/Residential/Residence.tscn"
const RESIDENTIAL_STONE_HOUSE = "res://Assets/World/Buildings/Residential/Residence.tscn"

# Tier 1 (Sailors) Resources
const RESIDENTIAL_TENT_1_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/Tent1_idle.png")

const RESIDENTIAL_TENT_2_IDLE_45 = preload("res://Assets/World/Buildings/Residential/Sprites/Tent2_idle_45.png")
const RESIDENTIAL_TENT_2_IDLE_135 = preload("res://Assets/World/Buildings/Residential/Sprites/Tent2_idle_135.png")
const RESIDENTIAL_TENT_2_IDLE_225 = preload("res://Assets/World/Buildings/Residential/Sprites/Tent2_idle_225.png")
const RESIDENTIAL_TENT_2_IDLE_315 = preload("res://Assets/World/Buildings/Residential/Sprites/Tent2_idle_315.png")

const RESIDENTIAL_TENT_3_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/Tent3_idle.png")
const RESIDENTIAL_TENT_4_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/Tent4_idle.png")
const RESIDENTIAL_TENT_5_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/Tent5_idle.png")
const RESIDENTIAL_TENT_6_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/Tent6_idle.png")

const RESIDENTIAL_TENT_RUINED = preload("res://Assets/World/Buildings/Residential/Sprites/Tent_ruined.png")

# Tier 2 (Pioneers) Resources
const RESIDENTIAL_HUT_1_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/Hut1_idle.png")
const RESIDENTIAL_HUT_2_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/Hut2_idle.png")
const RESIDENTIAL_HUT_3_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/Hut3_idle.png")

# Tier 3 (Settlers) Resources
const RESIDENTIAL_HOUSE_TIMBER_FRAMED_1_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/HouseTimberFramed1_idle.png")
const RESIDENTIAL_HOUSE_TIMBER_FRAMED_2_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/HouseTimberFramed2_idle.png")
const RESIDENTIAL_HOUSE_TIMBER_FRAMED_3_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/HouseTimberFramed3_idle.png")

# Tier 4 (Citizens) Resources
const RESIDENTIAL_STONE_HOUSE_1_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/StoneHouse1_idle.png")
const RESIDENTIAL_STONE_HOUSE_2_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/StoneHouse2_idle.png")
const RESIDENTIAL_STONE_HOUSE_3_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/StoneHouse3_idle.png")
const RESIDENTIAL_STONE_HOUSE_4_IDLE = preload("res://Assets/World/Buildings/Residential/Sprites/StoneHouse4_idle.png")

# Tier 1 (Sailors) Sprites
const RESIDENTIAL_TENT_2_IDLE_ANIM = [
	RESIDENTIAL_TENT_2_IDLE_45,
	RESIDENTIAL_TENT_2_IDLE_135,
	RESIDENTIAL_TENT_2_IDLE_225,
	RESIDENTIAL_TENT_2_IDLE_315,
]

const RESIDENTIAL_TENT_IDLE = [
	RESIDENTIAL_TENT_1_IDLE,
	RESIDENTIAL_TENT_2_IDLE_ANIM, # 2nd tent is animated, treat differently
	RESIDENTIAL_TENT_3_IDLE,
	RESIDENTIAL_TENT_4_IDLE,
	RESIDENTIAL_TENT_5_IDLE,
	RESIDENTIAL_TENT_6_IDLE,
]

# Tier 2 (Pioneers) Sprites
const RESIDENTIAL_HUT_IDLE = [
	RESIDENTIAL_HUT_1_IDLE,
	RESIDENTIAL_HUT_2_IDLE,
	RESIDENTIAL_HUT_3_IDLE,
]

# Tier 3 (Settlers) Sprites
const RESIDENTIAL_HOUSE_TIMBER_FRAMED_IDLE = [
	RESIDENTIAL_HOUSE_TIMBER_FRAMED_1_IDLE,
	RESIDENTIAL_HOUSE_TIMBER_FRAMED_2_IDLE,
	RESIDENTIAL_HOUSE_TIMBER_FRAMED_3_IDLE,
]

# Tier 4 (Citizens) Sprites
const RESIDENTIAL_STONE_HOUSE_IDLE = [
	RESIDENTIAL_STONE_HOUSE_1_IDLE,
	RESIDENTIAL_STONE_HOUSE_2_IDLE,
	RESIDENTIAL_STONE_HOUSE_3_IDLE,
	RESIDENTIAL_STONE_HOUSE_4_IDLE,
]

const TIERS = [
	RESIDENTIAL_TENT_IDLE,
	RESIDENTIAL_HUT_IDLE,
	RESIDENTIAL_HOUSE_TIMBER_FRAMED_IDLE,
	RESIDENTIAL_STONE_HOUSE_IDLE,
]

@export_range(0, 4) var tier: int : set = set_tier
@export var variation: int : set = set_variation

func animate() -> void:
	match action:
		"idle":
			if tier == 0 and variation == 1: # the animated tent
				current_anim = RESIDENTIAL_TENT_2_IDLE_ANIM
				self.texture = RESIDENTIAL_TENT_2_IDLE_ANIM[self.rotation_index]
				_billboard.vframes = 5
				_billboard.hframes = 5
				_billboard.region_rect = Rect2(0, 0, 640, 640)
				_billboard.region_enabled = true

				_billboard.frame = next_frame()
			else:
				current_anim = null
				self.texture = TIERS[tier][variation]
				_billboard.vframes = 2
				_billboard.hframes = 2
				_billboard.region_enabled = false

func destroy() -> void:
	self.texture = RESIDENTIAL_TENT_RUINED

func set_tier(new_tier: int) -> void:
	var previous_tier = tier

	tier = clamp(new_tier, 0, TIERS.size() - 1)
	self.variation = wrapi(variation, 0, TIERS[tier].size())

	if tier > previous_tier:
		upgrade()
	else:
		downgrade()

func set_variation(new_variation: int) -> void:
	variation = wrapi(new_variation, 0, TIERS[tier].size())

func upgrade() -> void:
	pass # TODO

func downgrade() -> void:
	pass # TODO
