@tool
extends Building
class_name CannonFoundry

const CANNON_FOUNDRY_IDLE = preload("res://Assets/World/Buildings/CannonFoundry/Sprites/CannonFoundry_idle.png")
const CANNON_FOUNDRY_IDLE_FULL = preload("res://Assets/World/Buildings/CannonFoundry/Sprites/CannonFoundry_idle_full.png")

const CANNON_FOUNDRY_WORK_45 = preload("res://Assets/World/Buildings/CannonFoundry/Sprites/CannonFoundry_work_45.png")
const CANNON_FOUNDRY_WORK_135 = preload("res://Assets/World/Buildings/CannonFoundry/Sprites/CannonFoundry_work_135.png")
const CANNON_FOUNDRY_WORK_225 = preload("res://Assets/World/Buildings/CannonFoundry/Sprites/CannonFoundry_work_225.png")
const CANNON_FOUNDRY_WORK_315 = preload("res://Assets/World/Buildings/CannonFoundry/Sprites/CannonFoundry_work_315.png")

const CANNON_FOUNDRY_WORK_ANIM = [
	CANNON_FOUNDRY_WORK_45,
	CANNON_FOUNDRY_WORK_135,
	CANNON_FOUNDRY_WORK_225,
	CANNON_FOUNDRY_WORK_315,
]

func animate() -> void:
	match action:
		"idle":
			current_anim = null
			self.texture = CANNON_FOUNDRY_IDLE
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"idle_full":
			current_anim = null
			self.texture = CANNON_FOUNDRY_IDLE_FULL
			_billboard.vframes = 2
			_billboard.hframes = 2
			_billboard.region_rect = Rect2(0, 0, 384, 384)
			_billboard.region_enabled = true

		"work":
			current_anim = CANNON_FOUNDRY_WORK_ANIM
			self.texture = CANNON_FOUNDRY_WORK_ANIM[self.rotation_index]
			_billboard.vframes = 7
			_billboard.hframes = 20
			_billboard.region_rect = Rect2(0, 0, 3840, 1344)
			_billboard.region_enabled = true

			_billboard.frame = next_frame()

	super()
