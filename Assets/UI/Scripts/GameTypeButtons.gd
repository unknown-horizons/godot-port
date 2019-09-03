extends VBoxContainer

func _ready() -> void:
	get_child(2).get_node("CheckBox").pressed = true
