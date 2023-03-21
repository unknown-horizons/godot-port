@tool
extends Building
class_name SugarField

const SUGAR_FIELD_IDLE = preload("res://Assets/World/Buildings/Agricultural/SugarField/Sprites/SugarField_idle.png")
const SUGAR_FIELD_IDLE_FULL = preload("res://Assets/World/Buildings/Agricultural/SugarField/Sprites/SugarField_idle_full.png")

#const SUGAR_FIELD_WORK_45 = preload("res://Assets/World/Buildings/Agricultural/SugarField/Sprites/SugarField_work_45.png")
#const SUGAR_FIELD_WORK_135 = preload("res://Assets/World/Buildings/Agricultural/SugarField/Sprites/SugarField_work_135.png")
#const SUGAR_FIELD_WORK_225 = preload("res://Assets/World/Buildings/Agricultural/SugarField/Sprites/SugarField_work_225.png")
#const SUGAR_FIELD_WORK_315 = preload("res://Assets/World/Buildings/Agricultural/SugarField/Sprites/SugarField_work_315.png")

#const SUGAR_FIELD_WORK_ANIM = [
#	SUGAR_FIELD_WORK_45,
#	SUGAR_FIELD_WORK_135,
#	SUGAR_FIELD_WORK_225,
#	SUGAR_FIELD_WORK_315,
#]
const SUGAR_FIELD_WORK_ANIM = preload("res://Assets/World/Buildings/Agricultural/SugarField/Sprites/SugarField_work_anim.png")
const SUGAR_FIELD_WORK_ANIM_REGION_Y = [
	0, 192, 384, 576
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = SUGAR_FIELD_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"idle_full":
			current_anim = null
			self.texture = SUGAR_FIELD_IDLE_FULL
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"work":
				current_anim = SUGAR_FIELD_WORK_ANIM
				self.texture = SUGAR_FIELD_WORK_ANIM
				_billboard.vframes = 1
				_billboard.hframes = 5
				_billboard.region_rect = Rect2(0, SUGAR_FIELD_WORK_ANIM_REGION_Y[self.rotation_index], 960, 192)
				_billboard.region_enabled = true

				_billboard.frame = next_frame()

	super()
