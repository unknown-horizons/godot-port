@tool
extends Building
class_name Brickyard

const BRICKYARD_IDLE_BRICKS_00 = preload("res://Assets/World/Buildings/Brickyard/Sprites/Brickyard_idle.png")
const BRICKYARD_IDLE_BRICKS_01 = preload("res://Assets/World/Buildings/Brickyard/Sprites/Brickyard_idle_bricks_01.png")
const BRICKYARD_IDLE_BRICKS_02 = preload("res://Assets/World/Buildings/Brickyard/Sprites/Brickyard_idle_bricks_02.png")
const BRICKYARD_IDLE_BRICKS_03 = preload("res://Assets/World/Buildings/Brickyard/Sprites/Brickyard_idle_bricks_03.png")
const BRICKYARD_IDLE_BRICKS_04 = preload("res://Assets/World/Buildings/Brickyard/Sprites/Brickyard_idle_bricks_04.png")

const BRICKYARD_IDLE = [
	BRICKYARD_IDLE_BRICKS_00,
	BRICKYARD_IDLE_BRICKS_01,
	BRICKYARD_IDLE_BRICKS_02,
	BRICKYARD_IDLE_BRICKS_03,
	BRICKYARD_IDLE_BRICKS_04
]

#const BRICKYARD_WORK_ANIM = [
#	BRICKYARD_WORK_45,
#	BRICKYARD_WORK_135,
#	BRICKYARD_WORK_225,
#	BRICKYARD_WORK_315,
#]

#const BRICKYARD_BURN_ANIM = [
#	BRICKYARD_BURN_45,
#	BRICKYARD_BURN_135,
#	BRICKYARD_BURN_225,
#	BRICKYARD_BURN_315,
#]

@export_range(0, 4) var resource_amount := 0 : set = set_resource_amount

func set_resource_amount(new_resource_amount: int) -> void:
	resource_amount = new_resource_amount
	self.texture = BRICKYARD_IDLE[resource_amount]
