extends Node

const cursor_default = preload("res://Assets/UI/Cursors/cursor.png")
const cursor_attack = preload("res://Assets/UI/Cursors/cursor_attack.png")
const cursor_pipette = preload("res://Assets/UI/Cursors/cursor_pipette.png")
const cursor_rename = preload("res://Assets/UI/Cursors/cursor_rename.png")
const cursor_tear = preload("res://Assets/UI/Cursors/cursor_tear.png")

enum CURSOR_TYPES {CURSOR_DEFAULT,CURSOR_ATTACK,CURSOR_PIPETTE,CURSOR_RENAME,CURSOR_TEAR} 

var cursor_dict = {CURSOR_TYPES.CURSOR_DEFAULT:cursor_default,
					CURSOR_TYPES.CURSOR_ATTACK:cursor_attack,
					CURSOR_TYPES.CURSOR_PIPETTE:cursor_pipette,
					CURSOR_TYPES.CURSOR_RENAME:cursor_rename,
					CURSOR_TYPES.CURSOR_RENAME:cursor_tear
				}
var current_cursor:int = CURSOR_TYPES.CURSOR_DEFAULT

func _ready()->void:
	set_cursor(CURSOR_TYPES.CURSOR_DEFAULT)

func set_cursor(new_cursor:int)->void:
	Input.set_custom_mouse_cursor(cursor_dict[new_cursor])
	current_cursor = new_cursor

func get_cursor()->int:
	return current_cursor
