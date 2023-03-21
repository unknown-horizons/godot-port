@tool
extends Building
class_name MainSquare

# Tiers
const MAIN_SQUARE = "res://Assets/World/Buildings/MainSquare/MainSquare.tscn"
const MAIN_SQUARE_WOODEN = "res://Assets/World/Buildings/MainSquare/MainSquare.tscn"
const MAIN_SQUARE_TIMBER_FRAMED = "res://Assets/World/Buildings/MainSquare/MainSquare.tscn"
const MAIN_SQUARE_STONE = "res://Assets/World/Buildings/MainSquare/MainSquare.tscn"

# Tier 1 (Sailors) Resources
const MAIN_SQUARE_IDLE_45 = preload("res://Assets/World/Buildings/MainSquare/Sprites/MainSquare_idle_45.png")
const MAIN_SQUARE_IDLE_135 = preload("res://Assets/World/Buildings/MainSquare/Sprites/MainSquare_idle_135.png")
const MAIN_SQUARE_IDLE_225 = preload("res://Assets/World/Buildings/MainSquare/Sprites/MainSquare_idle_225.png")
const MAIN_SQUARE_IDLE_315 = preload("res://Assets/World/Buildings/MainSquare/Sprites/MainSquare_idle_315.png")

# Tier 2 (Pioneers) Resources
const MAIN_SQUARE_WOODEN_IDLE = preload("res://Assets/World/Buildings/MainSquare/Sprites/MainSquareWooden_idle.png")

# Tier 3 (Settlers) Resources
const MAIN_SQUARE_TIMBER_FRAMED_IDLE = preload("res://Assets/World/Buildings/MainSquare/Sprites/MainSquareTimberFramed_idle.png")

# Tier 4 (Citizens) Resources
const MAIN_SQUARE_STONE_IDLE = preload("res://Assets/World/Buildings/MainSquare/Sprites/MainSquareStone_idle.png")

# Tier 1 (Sailors) Sprites
const MAIN_SQUARE_IDLE_ANIM = [
	MAIN_SQUARE_IDLE_45,
	MAIN_SQUARE_IDLE_135,
	MAIN_SQUARE_IDLE_225,
	MAIN_SQUARE_IDLE_315,
]

# Tier 2 (Pioneers) Sprites
# Tier 3 (Settlers) Sprites
# Tier 4 (Citizens) Sprites

const TIERS = [
	MAIN_SQUARE_IDLE_ANIM,
	MAIN_SQUARE_WOODEN_IDLE,
	MAIN_SQUARE_TIMBER_FRAMED_IDLE,
	MAIN_SQUARE_STONE_IDLE,
]

@export_range(0, 4) var tier: int : set = set_tier

func animate() -> void:
	match action:
		"idle":
			# As of now, only 1st tier is animated
			if tier == 0:
				current_anim = TIERS[tier]
				self.texture = TIERS[tier][self.rotation_index]
				_billboard.vframes = 2
				_billboard.hframes = 13
				_billboard.region_rect = Rect2(0, 0, 4992, 448)
				_billboard.region_enabled = true

				_billboard.frame = next_frame()
			else:
				current_anim = null
				self.texture = TIERS[tier]
				_billboard.vframes = 2
				_billboard.hframes = 2
				_billboard.region_rect = Rect2(0, 0, 768, 448)
				_billboard.region_enabled = true

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
