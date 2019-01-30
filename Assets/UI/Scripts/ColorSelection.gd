extends HBoxContainer

func _ready():
	for choice in $Choices.get_children():
		choice.connect("gui_input", self, "_on_choice_gui_input", [choice])


func _on_choice_gui_input(event, choice):
	if event is InputEventMouseButton and event.pressed:
		$SelectedColor.color = choice.color
