extends HBoxContainer

export var type = ""

func _ready():
	$Label.text = type


func _on_pressed():
	for type_button in get_parent().get_children():
		if type_button != self:
			type_button.get_node("CheckBox").pressed = false
