@tool
extends Building
class_name Brewery

const BREWERY_IDLE = preload("res://Assets/World/Buildings/Brewery/Sprites/Brewery_idle.png")
const BREWERY_IDLE_FULL = preload("res://Assets/World/Buildings/Brewery/Sprites/Brewery_idle_full.png")

const BREWERY_WORK_45 = preload("res://Assets/World/Buildings/Brewery/Sprites/Brewery_work_45.png")
const BREWERY_WORK_135 = preload("res://Assets/World/Buildings/Brewery/Sprites/Brewery_work_135.png")
const BREWERY_WORK_225 = preload("res://Assets/World/Buildings/Brewery/Sprites/Brewery_work_225.png")
const BREWERY_WORK_315 = preload("res://Assets/World/Buildings/Brewery/Sprites/Brewery_work_315.png")

const BREWERY_WORK_ANIM = [
	BREWERY_WORK_45,
	BREWERY_WORK_135,
	BREWERY_WORK_225,
	BREWERY_WORK_315,
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = BREWERY_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_enabled = false

		"idle_full":
			current_anim = null
			self.texture = BREWERY_IDLE_FULL
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_enabled = false

		"work":
			current_anim = BREWERY_WORK_ANIM
			self.texture = BREWERY_WORK_ANIM[self.rotation_index]
			_billboard.vframes = 4
			_billboard.hframes = 4
			_billboard.region_enabled = false

			_billboard.frame = next_frame()

	super()
