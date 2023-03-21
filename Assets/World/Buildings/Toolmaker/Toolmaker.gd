@tool
extends Building
class_name Toolmaker

const TOOLMAKER_IDLE = preload("res://Assets/World/Buildings/Toolmaker/Sprites/Toolmaker_idle.png")

const TOOLMAKER_WORK_ANIM = preload("res://Assets/World/Buildings/Toolmaker/Sprites/Toolmaker_work_anim.png")
const TOOLMAKER_WORK_ANIM_REGION_Y = [
	98*0, 98*1, 98*2, 98*3
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = TOOLMAKER_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 256, 196)
			_billboard.region_enabled = true

		"work":
			current_anim = TOOLMAKER_WORK_ANIM
			self.texture = TOOLMAKER_WORK_ANIM
			_billboard.vframes = 1
			_billboard.hframes = 8
			_billboard.region_rect = Rect2(0, TOOLMAKER_WORK_ANIM_REGION_Y[self.rotation_index], 1024, 98)
			_billboard.region_enabled = true

			_billboard.frame = next_frame()

	super()
