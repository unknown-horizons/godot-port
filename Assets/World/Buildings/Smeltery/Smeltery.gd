@tool
extends Building
class_name Smeltery

const SMELTERY_IDLE = preload("res://Assets/World/Buildings/Smeltery/Sprites/Smeltery_idle.png")

const SMELTERY_WORK_ANIM = preload("res://Assets/World/Buildings/Smeltery/Sprites/Smeltery_work.png")
const SMELTERY_WORK_ANIM_REGION_Y = [
	155*0, 155*1, 155*2, 155*3
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = SMELTERY_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 512, 310)
			_billboard.region_enabled = true

		"work":
			current_anim = SMELTERY_WORK_ANIM
			self.texture = SMELTERY_WORK_ANIM
			_billboard.vframes = 1
			_billboard.hframes = 6
			_billboard.region_rect = Rect2(0, SMELTERY_WORK_ANIM_REGION_Y[self.rotation_index], 1536, 155)
			_billboard.region_enabled = true

			_billboard.frame = next_frame()

	super()
