extends Node

enum CursorType {
	CURSOR_DEFAULT,
	CURSOR_ATTACK,
	CURSOR_PIPETTE,
	CURSOR_RENAME,
	CURSOR_TEAR,
}

const CURSOR_DEFAULT = preload("res://Assets/UI/Images/Cursors/cursor.png")
const CURSOR_ATTACK = preload("res://Assets/UI/Images/Cursors/cursor_attack.png")
const CURSOR_PIPETTE = preload("res://Assets/UI/Images/Cursors/cursor_pipette.png")
const CURSOR_RENAME = preload("res://Assets/UI/Images/Cursors/cursor_rename.png")
const CURSOR_TEAR = preload("res://Assets/UI/Images/Cursors/cursor_tear.png")

var cursors = {
	CursorType.CURSOR_DEFAULT: CURSOR_DEFAULT,
	CursorType.CURSOR_ATTACK: CURSOR_ATTACK,
	CursorType.CURSOR_PIPETTE: CURSOR_PIPETTE,
	CursorType.CURSOR_RENAME: CURSOR_RENAME,
	CursorType.CURSOR_TEAR: CURSOR_TEAR
}

var cursor: int = CursorType.CURSOR_DEFAULT : get = get_cursor, set = set_cursor

func _ready() -> void:
	self.cursor = CursorType.CURSOR_DEFAULT

func set_cursor(new_cursor: int) -> void:
	cursor = new_cursor
	Input.set_custom_mouse_cursor(cursors[cursor])

func get_cursor() -> int:
	return cursor
