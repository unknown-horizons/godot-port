@tool
extends VBoxContainer

@export var show_details: bool : set = set_show_details

@onready var details = $VBoxContainer/Details

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if details == null: details = $VBoxContainer/Details
	else:
		set_process(false)

	show_details = details.visible

func set_show_details(new_show_details: bool) -> void:
	if details == null: return

	show_details = new_show_details
	details.visible = show_details

func _on_TextureButton_pressed() -> void:
	self.show_details = !show_details
