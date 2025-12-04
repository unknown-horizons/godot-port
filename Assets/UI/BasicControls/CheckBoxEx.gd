@tool
extends HBoxContainer
class_name CheckBoxEx

## CheckBox with a descriptive Label component

signal toggled(check_state) # bool

@export var description: String = "Unknown CheckBox:" : set = set_description
@export var checked: bool = false : set = set_checked

@onready var description_node := $LabelEx as LabelEx
@onready var check_box_node := $CheckBox as CheckBox

#func _ready():
#	gui_input.size = size

func set_description(new_description: String) -> void:
	if not is_inside_tree():
		await self.ready

	description = new_description

	description_node.text = description

func set_checked(new_checked: bool) -> void:
	if not is_inside_tree():
		await self.ready

	checked = new_checked

	check_box_node.button_pressed = checked

func _on_CheckBox_toggled(check_state: bool) -> void:
	checked = check_state

	emit_signal("toggled", checked)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_MOUSE_ENTER:
			description_node.add_theme_color_override("font_color", load(ProjectSettings.get_setting("gui/theme/custom")).get_color("font_hover_color", "CheckBox"))
		NOTIFICATION_MOUSE_EXIT:
			description_node.add_theme_color_override("font_color", load(ProjectSettings.get_setting("gui/theme/custom")).get_color("font_color", "CheckBox"))

func _on_CheckBoxEx_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_released("alt_command"):
			#print("Left click checked CheckBox")
			Audio.play_snd_click()
			check_box_node.button_pressed = !check_box_node.button_pressed
