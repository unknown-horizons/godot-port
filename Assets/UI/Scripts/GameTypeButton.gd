tool
extends HBoxContainer
class_name GameTypeButton

export(String) var type = "" setget set_new_type

onready var check_box := $CheckBox

func _ready() -> void:
	check_box.text = type

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if check_box == null:
			prints("Please reload the scene [{0}].".format([name]))
			set_process(false)
			return
		check_box.text = type
	else:
		set_process(false)

func set_new_type(new_type: String) -> void:
	type = new_type

func _on_pressed() -> void:
	Audio.play_snd_click()
	for type_button in get_parent().get_children():
		if type_button != self:
			type_button.get_node("CheckBox").pressed = false
