tool
extends HBoxContainer
class_name CheckBoxEx
# CheckBox with a descriptive Label component

signal toggled(check_state) # bool

export(String) var description := "Unknown CheckBox:" setget set_description
export(bool) var checked := false setget set_checked

onready var description_node := $LabelEx
onready var check_box_node := $CheckBox

#func _ready():
#	gui_input.rect_size = rect_size

func set_description(new_description: String) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	description = new_description

	description_node.text = description

func set_checked(new_checked: bool) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	checked = new_checked

	check_box_node.pressed = checked

func _on_CheckBox_toggled(check_state: bool) -> void:
	checked = check_state

	emit_signal("toggled", checked)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_MOUSE_ENTER:
			description_node.add_color_override("font_color", description_node.theme.get_color("font_color_hover", "CheckBox"))
		NOTIFICATION_MOUSE_EXIT:
			description_node.add_color_override("font_color", description_node.theme.get_color("font_color", "CheckBox"))

func _on_CheckBoxEx_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_released("alt_command"):
			#print("Left click on CheckBox")
			Audio.play_snd_click()
			check_box_node.pressed = !check_box_node.pressed

func _on_ready() -> void:
	if not description_node: description_node = $LabelEx
	if not check_box_node: check_box_node = $CheckBox
