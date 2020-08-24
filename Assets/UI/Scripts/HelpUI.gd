extends Control
class_name HelpUI

var parent = null

#onready var page_control = $CenterContainer/TextureRect/MarginContainer/HBoxContainer/LeftPage/PageControl
onready var page_control = find_node("PageControl")

func _ready() -> void:
	page_control.visible = true
	page_control.get_node("PrevButton").disabled = true
	page_control.get_node("NextButton").disabled = true

func _on_RichTextLabel_meta_clicked(meta):
	print(meta)
	OS.shell_open(meta)

func _on_OKButton_pressed():
	if parent != null:
		parent.visible = true
	queue_free()
