@tool
extends Building
class_name CattleRun

const CATTLE_RUN_IDLE = preload("res://Assets/World/Buildings/Agricultural/CattleRun/Sprites/CattleRun_idle.png")
const CATTLE_RUN_IDLE_FULL = preload("res://Assets/World/Buildings/Agricultural/CattleRun/Sprites/CattleRun_idle_full.png")

const CATTLE_RUN_WORK_45 = preload("res://Assets/World/Buildings/Agricultural/CattleRun/Sprites/CattleRun_work_45.png")
const CATTLE_RUN_WORK_135 = preload("res://Assets/World/Buildings/Agricultural/CattleRun/Sprites/CattleRun_work_135.png")
const CATTLE_RUN_WORK_225 = preload("res://Assets/World/Buildings/Agricultural/CattleRun/Sprites/CattleRun_work_225.png")
const CATTLE_RUN_WORK_315 = preload("res://Assets/World/Buildings/Agricultural/CattleRun/Sprites/CattleRun_work_315.png")

const CATTLE_RUN_WORK_ANIM = [
	CATTLE_RUN_WORK_45,
	CATTLE_RUN_WORK_135,
	CATTLE_RUN_WORK_225,
	CATTLE_RUN_WORK_315,
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = CATTLE_RUN_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"idle_full":
			current_anim = null
			self.texture = CATTLE_RUN_IDLE_FULL
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"work":
			# set new animation set and randomize frame for the initial time,
			# afterwards only iterate through frames
			if current_anim != null and current_anim[0].get_load_path().find("_work") == -1 or current_anim == null:
				current_anim = CATTLE_RUN_WORK_ANIM
				self.texture = CATTLE_RUN_WORK_ANIM[self.rotation_index]
				_billboard.vframes = 10
				_billboard.hframes = 15
				_billboard.region_rect = Rect2(0, 0, 2880, 1920)
				_billboard.region_enabled = true

				_billboard.frame = get_random_frame()
				#prints(self.name, "randomized frame:", _billboard.frame)
			else:
				_billboard.frame = next_frame()

	super()
