@tool
extends Building
class_name SaltPonds

const SALT_POND_IDLE = preload("res://Assets/World/Buildings/SaltPonds/Sprites/SaltPond_idle.png")
const SALT_POND_IDLE_FULL = preload("res://Assets/World/Buildings/SaltPonds/Sprites/SaltPond_idle_full.png")

const SALT_POND_WORK_ANIM = preload("res://Assets/World/Buildings/SaltPonds/Sprites/SaltPond_work_anim.png")
const SALT_POND_WORK_ANIM_REGION_Y = [
	32, 224, 416, 608
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = SALT_POND_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 256)
			_billboard.region_enabled = true

		"idle_full":
			current_anim = null
			self.texture = SALT_POND_IDLE_FULL
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 256)
			_billboard.region_enabled = true

		"work":
			current_anim = SALT_POND_WORK_ANIM
			self.texture = SALT_POND_WORK_ANIM
			_billboard.vframes = 1
			_billboard.hframes = 6
			_billboard.region_rect = Rect2(0, SALT_POND_WORK_ANIM_REGION_Y[self.rotation_index], 1152, 192)
			_billboard.region_enabled = true

			_billboard.frame = next_frame()

	super()
