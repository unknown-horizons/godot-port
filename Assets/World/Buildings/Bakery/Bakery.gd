@tool
extends Building
class_name Bakery

const BAKERY_IDLE = preload("res://Assets/World/Buildings/Bakery/Sprites/Bakery_idle.png")

const BAKERY_WORK_ANIM = preload("res://Assets/World/Buildings/Bakery/Sprites/Bakery_work_anim.png")
const BAKERY_WORK_ANIM_REGION_Y = [
	128*0, 128*1, 128*2, 128*3
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = BAKERY_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 256, 256)
			_billboard.region_enabled = true

		"work":
			current_anim = BAKERY_WORK_ANIM
			self.texture = BAKERY_WORK_ANIM
			_billboard.vframes = 1
			_billboard.hframes = 8
			_billboard.region_rect = Rect2(0, BAKERY_WORK_ANIM_REGION_Y[self.rotation_index], 1024, 128)
			_billboard.region_enabled = true

			_billboard.frame = next_frame()

	super()
