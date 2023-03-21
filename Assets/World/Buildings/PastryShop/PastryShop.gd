@tool
extends Building
class_name PastryShop

const PASTRY_SHOP_IDLE = preload("res://Assets/World/Buildings/PastryShop/Sprites/PastryShop_idle.png")

const PASTRY_SHOP_WORK_45 = preload("res://Assets/World/Buildings/PastryShop/Sprites/PastryShop_work_45.png")
const PASTRY_SHOP_WORK_135 = preload("res://Assets/World/Buildings/PastryShop/Sprites/PastryShop_work_135.png")
const PASTRY_SHOP_WORK_225 = preload("res://Assets/World/Buildings/PastryShop/Sprites/PastryShop_work_225.png")
const PASTRY_SHOP_WORK_315 = preload("res://Assets/World/Buildings/PastryShop/Sprites/PastryShop_work_315.png")

const PASTRY_SHOP_WORK_ANIM = [
	PASTRY_SHOP_WORK_45,
	PASTRY_SHOP_WORK_135,
	PASTRY_SHOP_WORK_225,
	PASTRY_SHOP_WORK_315
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = PASTRY_SHOP_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_enabled = false

		"work":
			current_anim = PASTRY_SHOP_WORK_ANIM
			self.texture = PASTRY_SHOP_WORK_ANIM[self.rotation_index]
			_billboard.vframes = 4
			_billboard.hframes = 4
			_billboard.region_enabled = false

			_billboard.frame = next_frame()

	super()
