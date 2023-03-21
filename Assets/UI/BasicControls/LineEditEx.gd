@tool
extends HBoxContainer
class_name LineEditEx

## LineEdit with a descriptive Label component.

signal text_change_rejected
signal text_changed(new_text: String)
signal text_submitted(new_text: String)

@export var description: String = "Descriptive Label:" : set = set_description
@export var text: String = "Example Text" : set = set_text

@export_enum("Left", "Center", "Right") var align_style = "Left" : set = set_align_style

#export var description_node_path: NodePath : set = set_description_node_path
#export var input_node_path: NodePath : set = set_input_node_path
#onready var description_node = get_node(description_node_path)
#onready var input_node = get_node(input_node_path)

#func set_description_node_path(new_description_node_path):
#	description_node_path = new_description_node_path
#	description_node = get_node(description_node_path)

#func set_input_node_path(new_input_node_path):
#	input_node_path = new_input_node_path
#	input_node = get_node(input_node_path)

@onready var description_node := $LabelEx
@onready var input_node := $LineEdit

func set_description(new_description: String) -> void:
	if not is_inside_tree():
		await self.ready

	description = new_description

	description_node.text = description

func set_text(new_text: String) -> void:
	if not is_inside_tree():
		await self.ready

	text = new_text

	input_node.text = text

func set_align_style(new_align_style: String) -> void:
	if not is_inside_tree():
		await self.ready

	align_style = new_align_style

	match align_style:
		"Left":
			move_child(input_node, description_node.get_index() + 1)
			description_node.align = 1
			description_node.visible = true
		"Center":
			description_node.visible = false
		"Right":
			move_child(description_node, input_node.get_index() + 1)
			description_node.align = 2
			description_node.visible = true

	input_node.align_style = align_style

func _on_LineEdit_text_change_rejected() -> void:
	emit_signal("text_change_rejected")

func _on_LineEdit_text_changed(new_text: String) -> void:
	text = new_text
	emit_signal("text_changed", text)

func _on_LineEdit_text_entered(new_text: String) -> void:
	text = new_text
	emit_signal("text_submitted", text)
