@tool
extends Building
class_name CocoaField

const COCOA_FIELD_IDLE = preload("res://Assets/World/Buildings/Agricultural/CocoaField/Sprites/CocoaField_idle.png")
const COCOA_FIELD_IDLE_FULL = preload("res://Assets/World/Buildings/Agricultural/CocoaField/Sprites/CocoaField_idle_full.png")

const COCOA_FIELD_WORK_ANIM = preload("res://Assets/World/Buildings/Agricultural/CocoaField/Sprites/CocoaField_work_anim.png")
const COCOA_FIELD_WORK_ANIM_REGION_Y = [
	192*0, 192*1, 192*2, 192*3
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = COCOA_FIELD_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"idle_full":
			current_anim = null
			self.texture = COCOA_FIELD_IDLE_FULL
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"work":
				current_anim = COCOA_FIELD_WORK_ANIM
				self.texture = COCOA_FIELD_WORK_ANIM
				_billboard.vframes = 1
				_billboard.hframes = 5
				_billboard.region_rect = Rect2(0, COCOA_FIELD_WORK_ANIM_REGION_Y[self.rotation_index], 960, 192)
				_billboard.region_enabled = true

				_billboard.frame = next_frame()

	super()
