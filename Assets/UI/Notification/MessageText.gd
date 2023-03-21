@tool
extends Label
#class_name MessageText

## ❗TODO: Review code for Godot 4. Until then, keep unused.

@export_multiline var message_text: String : set = set_message_text

func _ready() -> void:
	set_message_text(message_text)

func set_message_text(new_message_text: String) -> void:
	message_text = new_message_text
	text = message_text

	# After the text has been updated, decide whether
	# resizing of the font is appropriate or not
	var font = get("custom_fonts/font")
	font.set("size", 17) # default size to check against

	if get_line_count() > 2:
		# Make font unique so it won't mistakenly update other instances
		font = font.duplicate(true)
		add_theme_font_override("font", font)
		font.set("size", 15)
	else:
		font.set("size", 17)

	if get_line_count() > 3:
		printerr("Text [{0}] at {1} is too long.".format([text, self.name]))
