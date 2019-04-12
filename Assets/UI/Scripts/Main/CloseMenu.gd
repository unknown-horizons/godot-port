extends Button

var _parent: VBoxContainer

func _ready() -> void:
	_parent = get_parent()

func _pressed() -> void:
	_parent.toggle_visible()
