@tool
extends Building
class_name Alvearies

const ALVEARIES_IDLE_45 = preload("res://Assets/World/Buildings/Agricultural/Alvearies/Sprites/Alvearies_idle_45.png")
const ALVEARIES_IDLE_135 = preload("res://Assets/World/Buildings/Agricultural/Alvearies/Sprites/Alvearies_idle_135.png")
const ALVEARIES_IDLE_225 = preload("res://Assets/World/Buildings/Agricultural/Alvearies/Sprites/Alvearies_idle_225.png")
const ALVEARIES_IDLE_315 = preload("res://Assets/World/Buildings/Agricultural/Alvearies/Sprites/Alvearies_idle_315.png")

const ALVEARIES_IDLE_ANIM = [
	ALVEARIES_IDLE_45,
	ALVEARIES_IDLE_135,
	ALVEARIES_IDLE_225,
	ALVEARIES_IDLE_315
]

func animate() -> void:
	match action:
		"idle":
			current_anim = ALVEARIES_IDLE_ANIM
			self.texture = ALVEARIES_IDLE_ANIM[self.rotation_index]
			_billboard.vframes = 4
			_billboard.hframes = 5
			_billboard.region_rect = Rect2(0, 0, 960, 768)
			_billboard.region_enabled = true

			_billboard.frame = next_frame()
