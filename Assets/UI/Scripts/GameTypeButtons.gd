extends VBoxContainer

func _ready():
	get_child(0).get_node("CheckBox").pressed = true
