tool
extends Building
class_name Residence

#func update_offset(new_rotation):
#	var new_offset = Vector2()
#	match int(round(new_rotation)):
#		-45:
#			new_offset = Vector2(0, 42)
#		45:
#			new_offset = Vector2(16, 32)
#		135:
#			new_offset = Vector2(0, 16)
#		-135:
#			new_offset = Vector2(-29, 32)
#
#	#print("Update offset for {0}: {1}".format([self.name, new_offset]))
#	_billboard.offset = new_offset

const RESIDENTIAL_TENT_1_IDLE = preload("res://Assets/World/Buildings/Sailors/Residential/Sprites/Tent1_idle.png")
const RESIDENTIAL_TENT_2_IDLE_ANIM = preload("res://Assets/World/Buildings/Sailors/Residential/Sprites/Tent2_idle_anim.png")
const RESIDENTIAL_TENT_3_IDLE = preload("res://Assets/World/Buildings/Sailors/Residential/Sprites/Tent3_idle.png")
const RESIDENTIAL_TENT_4_IDLE = preload("res://Assets/World/Buildings/Sailors/Residential/Sprites/Tent4_idle.png")
const RESIDENTIAL_TENT_5_IDLE = preload("res://Assets/World/Buildings/Sailors/Residential/Sprites/Tent5_idle.png")
const RESIDENTIAL_TENT_6_IDLE = preload("res://Assets/World/Buildings/Sailors/Residential/Sprites/Tent6_idle.png")

const RESIDENTIAL_TENT_RUINED = preload("res://Assets/World/Buildings/Sailors/Residential/Sprites/Tent_ruined.png")

const RESIDENTIAL_IDLE = [
	RESIDENTIAL_TENT_1_IDLE,
	RESIDENTIAL_TENT_2_IDLE_ANIM,
	RESIDENTIAL_TENT_3_IDLE,
	RESIDENTIAL_TENT_4_IDLE,
	RESIDENTIAL_TENT_5_IDLE,
	RESIDENTIAL_TENT_6_IDLE,
	RESIDENTIAL_TENT_RUINED
]

enum TentSprite {
	TENT_1,
	TENT_2,
	TENT_3,
	TENT_4,
	TENT_5,
	TENT_6
}

export(int, "Tent 1", "Tent 2", "Tent 3", "Tent 4", "Tent 5", "Tent 6") var variation setget set_variation

func set_variation(new_variation) -> void:
	variation = new_variation
	set_texture(RESIDENTIAL_IDLE[variation])

func _ready() -> void:
	pass
	#current_anim = RESIDENTAL_TENT_2_IDLE_ANIM
	
func animate() -> void:
	match action:
		"idle":
			if texture == RESIDENTIAL_TENT_2_IDLE_ANIM:
				_billboard.vframes = 5
				_billboard.hframes = 5
				_billboard.region_rect = Rect2(0, 0, 640, 640)
				_billboard.region_enabled = true
				
				_billboard.frame = next_frame()
			else:
				_billboard.vframes = 2
				_billboard.hframes = 2
				_billboard.region_enabled = false

func destroy() -> void:
	set_texture(RESIDENTIAL_TENT_RUINED)
