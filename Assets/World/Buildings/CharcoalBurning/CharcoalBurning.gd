@tool
extends Building
class_name CharcoalBurning

const CHARCOAL_BURNING_IDLE = preload("res://Assets/World/Buildings/CharcoalBurning/Sprites/CharcoalBurning_idle.png")
const CHARCOAL_BURNING_IDLE_FULL = preload("res://Assets/World/Buildings/CharcoalBurning/Sprites/CharcoalBurning_idle_full.png")

const CHARCOAL_BURNING_WORK_ANIM = preload("res://Assets/World/Buildings/CharcoalBurning/Sprites/CharcoalBurning_work_anim.png")
const CHARCOAL_BURNING_WORK_ANIM_REGION_Y = [
	108*0, 108*1, 108*2, 108*3
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = CHARCOAL_BURNING_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 316, 216)
			_billboard.region_enabled = true

		"idle_full":
			current_anim = null
			self.texture = CHARCOAL_BURNING_IDLE_FULL
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 316, 216)
			_billboard.region_enabled = true

		"work":
			current_anim = CHARCOAL_BURNING_WORK_ANIM
			self.texture = CHARCOAL_BURNING_WORK_ANIM
			_billboard.vframes = 1
			_billboard.hframes = 7
			_billboard.region_rect = Rect2(0, CHARCOAL_BURNING_WORK_ANIM_REGION_Y[self.rotation_index], 1106, 108)
			_billboard.region_enabled = true

			_billboard.frame = next_frame()

	super()
