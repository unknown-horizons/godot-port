extends Button

var parent : VBoxContainer

func _ready():
	parent = get_parent()

func _pressed():
	parent.toggle_visible()
	pass
