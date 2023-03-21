@tool
extends BookMenu
class_name HelpUI

#onready var page_control = $CenterContainer/TextureRect/MarginContainer/HBoxContainer/LeftPage/PageControl
@onready var page_control = find_child("PageControl")

func _ready() -> void:
	page_control.visible = true
	page_control.get_node("PrevButton").disabled = true
	page_control.get_node("NextButton").disabled = true

	# These contain hyperlinks.
	(%Pages/HelpUIInfo.find_child("RichTextLabel5") as RichTextLabel).meta_clicked.connect(
		Callable(self, "_on_RichTextLabel_meta_clicked")
	)
	(%Pages/HelpUIInfo.find_child("RichTextLabel6") as RichTextLabel).meta_clicked.connect(
		Callable(self, "_on_RichTextLabel_meta_clicked")
	)

func _on_RichTextLabel_meta_clicked(meta: Variant) -> void:
	print(meta)
	OS.shell_open(meta)

func _on_OKButton_pressed() -> void:
	if parent != null:
		parent.visible = true
	queue_free()
