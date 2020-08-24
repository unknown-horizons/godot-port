tool
extends HBoxContainer
class_name LineEditEx
# LineEdit with a descriptive Label component

signal text_change_rejected
signal text_changed(new_text) # String
signal text_entered(new_text) # String

export(String) var description := "Descriptive Label:" setget set_description
export(String) var text := "Example Text" setget set_text

export(String, "Left", "Center", "Right") var align_style := "Left" setget set_align_style

#export(NodePath) var description_node_path setget set_description_node_path
#export(NodePath) var input_node_path setget set_input_node_path
#onready var description_node = get_node(description_node_path)
#onready var input_node = get_node(input_node_path)

#func set_description_node_path(new_description_node_path):
#	description_node_path = new_description_node_path
#	description_node = get_node(description_node_path)

#func set_input_node_path(new_input_node_path):
#	input_node_path = new_input_node_path
#	input_node = get_node(input_node_path)

onready var description_node := $LabelEx
onready var input_node := $LineEdit

func set_description(new_description: String) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	description = new_description

	description_node.text = description

func set_text(new_text: String) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	text = new_text

	input_node.text = text

func set_align_style(new_align_style: String) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	align_style = new_align_style

	match align_style:
		"Left":
			move_child(input_node, description_node.get_index() + 1)
			description_node.align = Label.ALIGN_LEFT
			description_node.visible = true
		"Center":
			description_node.visible = false
		"Right":
			move_child(description_node, input_node.get_index() + 1)
			description_node.align = Label.ALIGN_RIGHT
			description_node.visible = true

	input_node.align_style = align_style

func _on_LineEdit_text_change_rejected() -> void:
	emit_signal("text_change_rejected")

func _on_LineEdit_text_changed(new_text: String) -> void:
	text = new_text
	emit_signal("text_changed", text)

func _on_LineEdit_text_entered(new_text: String) -> void:
	text = new_text
	emit_signal("text_entered", text)

func _on_ready() -> void:
	if not description_node: description_node = $LabelEx
	if not input_node: input_node = $LineEdit
