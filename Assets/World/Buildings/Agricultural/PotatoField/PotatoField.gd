@tool
extends Building
class_name PotatoField

const POTATO_FIELD_IDLE = preload("res://Assets/World/Buildings/Agricultural/PotatoField/Sprites/PotatoField_idle.png")
const POTATO_FIELD_IDLE_FULL = preload("res://Assets/World/Buildings/Agricultural/PotatoField/Sprites/PotatoField_idle_full.png")

#const POTATO_FIELD_WORK_45 = preload("res://Assets/World/Buildings/Agricultural/PotatoField/Sprites/PotatoField_work_45.png")
#const POTATO_FIELD_WORK_135 = preload("res://Assets/World/Buildings/Agricultural/PotatoField/Sprites/PotatoField_work_135.png")
#const POTATO_FIELD_WORK_225 = preload("res://Assets/World/Buildings/Agricultural/PotatoField/Sprites/PotatoField_work_225.png")
#const POTATO_FIELD_WORK_315 = preload("res://Assets/World/Buildings/Agricultural/PotatoField/Sprites/PotatoField_work_315.png")

#const POTATO_FIELD_WORK_ANIM = [
#	POTATO_FIELD_WORK_45,
#	POTATO_FIELD_WORK_135,
#	POTATO_FIELD_WORK_225,
#	POTATO_FIELD_WORK_315,
#]
const POTATO_FIELD_WORK_ANIM = preload("res://Assets/World/Buildings/Agricultural/PotatoField/Sprites/PotatoField_work_anim.png")
const POTATO_FIELD_WORK_ANIM_REGION = [
	0, 192, 384, 576
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = POTATO_FIELD_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"idle_full":
			current_anim = null
			self.texture = POTATO_FIELD_IDLE_FULL
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"work":
				current_anim = POTATO_FIELD_WORK_ANIM
				self.texture = POTATO_FIELD_WORK_ANIM
				_billboard.vframes = 1
				_billboard.hframes = 5
				_billboard.region_rect = Rect2(0, POTATO_FIELD_WORK_ANIM_REGION[self.rotation_index], 960, 192)
				_billboard.region_enabled = true

				_billboard.frame = next_frame()

	super()
