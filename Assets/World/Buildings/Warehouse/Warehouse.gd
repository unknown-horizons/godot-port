@tool
extends Building
class_name Warehouse

# Tiers
const WAREHOUSE = "res://Assets/World/Buildings/Warehouse/Warehouse.tscn"
const WAREHOUSE_WOODEN = "res://Assets/World/Buildings/Warehouse/Warehouse.tscn"
const WAREHOUSE_TIMBER_FRAMED = "res://Assets/World/Buildings/Warehouse/Warehouse.tscn"
const WAREHOUSE_STONE = "res://Assets/World/Buildings/Warehouse/Warehouse.tscn"

# Tier 1 (Sailors) Resources
const WAREHOUSE_IDLE = preload("res://Assets/World/Buildings/Warehouse/Sprites/Warehouse_idle.png")

# Tier 2 (Pioneers) Resources
const WAREHOUSE_WOODEN_IDLE = preload("res://Assets/World/Buildings/Warehouse/Sprites/WarehouseWooden_idle.png")

# Tier 3 (Settlers) Resources
const WAREHOUSE_TIMBER_FRAMED_IDLE = preload("res://Assets/World/Buildings/Warehouse/Sprites/WarehouseTimberFramed_idle.png")

# Tier 4 (Citizens) Resources
const WAREHOUSE_STONE_IDLE = preload("res://Assets/World/Buildings/Warehouse/Sprites/WarehouseStone_idle.png")

# Tier 1 (Sailors) Sprites
# Tier 2 (Pioneers) Sprites
# Tier 3 (Settlers) Sprites
# Tier 4 (Citizens) Sprites

const TIERS = [
	WAREHOUSE_IDLE,
	WAREHOUSE_WOODEN_IDLE,
	WAREHOUSE_TIMBER_FRAMED_IDLE,
	WAREHOUSE_STONE_IDLE,
]

@export var tier: int : set = set_tier # (int, 0, 4)

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = TIERS[tier]
			match tier:
				0:
					_billboard.vframes = 2
					_billboard.hframes = 2
					_billboard.region_rect = Rect2(0, 0, 384, 256)
					_billboard.region_enabled = true
					_billboard.offset = Vector2(0, 10)
				1, 2, 3:
					_billboard.vframes = 2
					_billboard.hframes = 2
					_billboard.region_rect = Rect2(0, 0, 384, 384)
					_billboard.region_enabled = true
					_billboard.offset = Vector2(0, 40)

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
