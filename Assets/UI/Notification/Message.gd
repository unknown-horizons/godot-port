@tool
extends HBoxContainer

enum MessageType {
	ANCHOR,
	DISASTER_FIRE,
	DISASTER_PLAGUE,
	LETTER,
	MONEY,
	SAVE,
	SYSTEM
}

@export var message_type: MessageType = MessageType.LETTER : set = set_message_type
@export_multiline var message_text: String : set = set_message_text

@onready var message_button := $MessageButton
@onready var message_text_panel := $MessageText

func _ready() -> void:
	set_message_text(message_text)
	set_message_type(message_type)

	if not Engine.is_editor_hint():
		Audio.play_snd("ships_bell")

func set_message_type(new_message_type: int) -> void:
	message_type = new_message_type
	if message_button != null:
		message_button.message_type = message_type

func set_message_text(new_message_text: String) -> void:
	message_text = new_message_text
	if message_text_panel != null:
		message_text_panel.text = message_text

func _on_MessageButton_pressed() -> void:
	queue_free()

func _on_MessageButton_mouse_entered() -> void:
	message_text_panel.visible = true

func _on_MessageButton_mouse_exited() -> void:
	message_text_panel.visible = false

func _on_Timer_timeout() -> void:
	message_text_panel.visible = false
