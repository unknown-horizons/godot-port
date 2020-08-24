tool
extends VBoxContainer
class_name CaptionBlock

export(String) var text := "This is a Book Title" setget set_text

onready var caption := $Caption

func set_text(new_text: String) -> void:
	if not is_inside_tree(): yield(self, "ready")
	text = new_text

	caption.text = text
