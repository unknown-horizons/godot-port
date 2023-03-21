@tool
extends Building
class_name Windmill

const WINDMILL_IDLE = preload("res://Assets/World/Buildings/Windmill/Sprites/Windmill_idle.png")
const WINDMILL_IDLE_FULL = preload("res://Assets/World/Buildings/Windmill/Sprites/Windmill_idle_full.png")

const WINDMILL_WORK_45 = preload("res://Assets/World/Buildings/Windmill/Sprites/Windmill_work_45.png")
const WINDMILL_WORK_135 = preload("res://Assets/World/Buildings/Windmill/Sprites/Windmill_work_135.png")
const WINDMILL_WORK_225 = preload("res://Assets/World/Buildings/Windmill/Sprites/Windmill_work_225.png")
const WINDMILL_WORK_315 = preload("res://Assets/World/Buildings/Windmill/Sprites/Windmill_work_315.png")

const WINDMILL_WORK_ANIM = [
	WINDMILL_WORK_45,
	WINDMILL_WORK_135,
	WINDMILL_WORK_225,
	WINDMILL_WORK_315,
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = WINDMILL_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 256, 256)

		"idle_full":
			current_anim = null
			self.texture = WINDMILL_IDLE_FULL
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 256, 256)

		"work":
			# set new animation set and randomize frame for the initial time,
			# afterwards only iterate through frames
			if current_anim != null and current_anim[0].get_load_path().find("_work") == -1 or current_anim == null:
				current_anim = WINDMILL_WORK_ANIM
				self.texture = WINDMILL_WORK_ANIM[self.rotation_index]
				_billboard.vframes = 5
				_billboard.hframes = 6
				_billboard.region_rect = Rect2(0, 0, 768, 640)

				_billboard.frame = get_random_frame()
				#prints(self.name, "randomized frame:", _billboard.frame)
			else:
				_billboard.frame = next_frame()

	super()
