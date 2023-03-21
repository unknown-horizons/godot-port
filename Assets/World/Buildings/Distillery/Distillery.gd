@tool
extends Building
class_name Distillery

const DISTILLERY_IDLE = preload("res://Assets/World/Buildings/Distillery/Sprites/Distillery_idle.png")

const DISTILLERY_WORK_ANIM = preload("res://Assets/World/Buildings/Distillery/Sprites/Distillery_work_anim.png")
const DISTILLERY_WORK_ANIM_REGION_Y = [
	98*0, 98*1, 98*2, 98*3
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = DISTILLERY_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 256, 196)
			_billboard.region_enabled = true

		"work":
			current_anim = DISTILLERY_WORK_ANIM
			self.texture = DISTILLERY_WORK_ANIM
			_billboard.vframes = 1
			_billboard.hframes = 5
			_billboard.region_rect = Rect2(0, DISTILLERY_WORK_ANIM_REGION_Y[self.rotation_index], 640, 98)
			_billboard.region_enabled = true

			_billboard.frame = next_frame()

	super()
