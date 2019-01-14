extends Button

var _parent # : VBoxContainer

func _ready():
	_parent = get_parent()

func _pressed():
	_parent.toggle_visible()
