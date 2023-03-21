@tool
extends Building
class_name Pasture

const PASTURE_IDLE = preload("res://Assets/World/Buildings/Agricultural/Pasture/Sprites/Pasture_idle.png")

const PASTURE_WORK_45 = preload("res://Assets/World/Buildings/Agricultural/Pasture/Sprites/Pasture_work_45.png")
const PASTURE_WORK_135 = preload("res://Assets/World/Buildings/Agricultural/Pasture/Sprites/Pasture_work_135.png")
const PASTURE_WORK_225 = preload("res://Assets/World/Buildings/Agricultural/Pasture/Sprites/Pasture_work_225.png")
const PASTURE_WORK_315 = preload("res://Assets/World/Buildings/Agricultural/Pasture/Sprites/Pasture_work_315.png")

const PASTURE_WORK_ANIM = [
	PASTURE_WORK_45,
	PASTURE_WORK_135,
	PASTURE_WORK_225,
	PASTURE_WORK_315,
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = PASTURE_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"work":
			# set new animation set and randomize frame for the initial time,
			# afterwards only iterate through frames
			if current_anim != null and current_anim[0].get_load_path().find("_work") == -1 or current_anim == null:
				current_anim = PASTURE_WORK_ANIM
				#update_rotation()
				self.texture = PASTURE_WORK_ANIM[self.rotation_index]
				_billboard.vframes = 10
				_billboard.hframes = 20
				_billboard.region_rect = Rect2(0, 0, 3840, 1920)
				_billboard.region_enabled = true

				_billboard.frame = get_random_frame()
				#prints("randomized frame:", _billboard.frame)
			else:
				_billboard.frame = next_frame()

	super()
