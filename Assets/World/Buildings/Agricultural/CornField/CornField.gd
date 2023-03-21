@tool
extends Building
class_name CornField

const CORN_FIELD_IDLE = preload("res://Assets/World/Buildings/Agricultural/CornField/Sprites/CornField_idle.png")
const CORN_FIELD_IDLE_FULL = preload("res://Assets/World/Buildings/Agricultural/CornField/Sprites/CornField_idle_full.png")

const CORN_FIELD_WORK_ANIM = preload("res://Assets/World/Buildings/Agricultural/CornField/Sprites/CornField_work_anim.png")
const CORN_FIELD_WORK_ANIM_REGION_Y = [
	192*0, 192*1, 192*2, 192*3
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = CORN_FIELD_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"idle_full":
			current_anim = null
			self.texture = CORN_FIELD_IDLE_FULL
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"work":
				current_anim = CORN_FIELD_WORK_ANIM
				self.texture = CORN_FIELD_WORK_ANIM
				_billboard.vframes = 1
				_billboard.hframes = 4
				_billboard.region_rect = Rect2(0, CORN_FIELD_WORK_ANIM_REGION_Y[self.rotation_index], 768, 192)
				_billboard.region_enabled = true

				_billboard.frame = next_frame()

	super()
