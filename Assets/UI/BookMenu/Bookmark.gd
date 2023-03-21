@tool
extends TextureButton

const BOOKMARK_LEFT = preload("res://Assets/UI/Images/Background/pickbelt_left.png")
const BOOKMARK_RIGHT = preload("res://Assets/UI/Images/Background/pickbelt_right.png")

const SIDES = [
	BOOKMARK_LEFT,
	BOOKMARK_RIGHT
]

@export_enum("Left", "Right") var side := 0:
	set(new_side):
		side = new_side
		texture_normal = SIDES[side]
