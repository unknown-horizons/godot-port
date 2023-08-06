@tool
extends VBoxContainer

@export var show_details: bool:
	set(value):
		if not is_inside_tree():
			await self.ready

		show_details = value
		details.visible = show_details

@onready var details = $VBoxContainer/Details

func _ready() -> void:
	show_details = details.visible

func _on_TextureButton_pressed() -> void:
	self.show_details = !show_details
