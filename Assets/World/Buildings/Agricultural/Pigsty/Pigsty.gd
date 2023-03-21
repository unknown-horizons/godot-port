@tool
extends Building
class_name Pigsty

const PIGSTY_IDLE = preload("res://Assets/World/Buildings/Agricultural/Pigsty/Sprites/Pigsty_idle.png")

const PIGSTY_WORK_45 = preload("res://Assets/World/Buildings/Agricultural/Pigsty/Sprites/Pigsty_work_45.png")
const PIGSTY_WORK_135 = preload("res://Assets/World/Buildings/Agricultural/Pigsty/Sprites/Pigsty_work_135.png")
const PIGSTY_WORK_225 = preload("res://Assets/World/Buildings/Agricultural/Pigsty/Sprites/Pigsty_work_225.png")
const PIGSTY_WORK_315 = preload("res://Assets/World/Buildings/Agricultural/Pigsty/Sprites/Pigsty_work_315.png")

const PIGSTY_WORK_ANIM = [
	PIGSTY_WORK_45,
	PIGSTY_WORK_135,
	PIGSTY_WORK_225,
	PIGSTY_WORK_315
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = PIGSTY_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"work":
			# set new animation set and randomize frame for the initial time,
			# afterwards only iterate through frames
			if current_anim != null and current_anim[0].get_load_path().find("_work") == -1 or current_anim == null:
				current_anim = PIGSTY_WORK_ANIM
				self.texture = PIGSTY_WORK_ANIM[self.rotation_index]
				_billboard.vframes = 8
				_billboard.hframes = 10
				_billboard.region_rect = Rect2(0, 0, 1920, 1536)
				_billboard.region_enabled = true

				_billboard.frame = get_random_frame()
				#prints(self.name, "randomized frame:", _billboard.frame)
			else:
				_billboard.frame = next_frame()

	super()
