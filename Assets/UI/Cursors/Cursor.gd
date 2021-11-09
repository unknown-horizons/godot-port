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
func _ready()->void:
	Input.set_custom_mouse_cursor(cursor_default)

func change_cursor(cursor_type:int)->void:
	Input.set_custom_mouse_cursor(cursor_dict[cursor_type])
