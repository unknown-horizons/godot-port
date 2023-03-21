@tool
extends TextureButton
class_name MessageButton

const MESSAGE_TEXTURES = [
	{	# Anchor
		"normal": preload("res://Assets/UI/Icons/Widgets/Messages/msg_anchor.png"),
		"pressed": preload("res://Assets/UI/Icons/Widgets/Messages/msg_anchor_d.png"),
		"hover": preload("res://Assets/UI/Icons/Widgets/Messages/msg_anchor_h.png")
	},
	{	# Disaster/Fire
		"normal": preload("res://Assets/UI/Icons/Widgets/Messages/msg_disaster_fire.png"),
		"pressed": preload("res://Assets/UI/Icons/Widgets/Messages/msg_disaster_fire_d.png"),
		"hover": preload("res://Assets/UI/Icons/Widgets/Messages/msg_disaster_fire_h.png")
	},
	{	# Disaster/Plague
		"normal": preload("res://Assets/UI/Icons/Widgets/Messages/msg_disaster_plague.png"),
		"pressed": preload("res://Assets/UI/Icons/Widgets/Messages/msg_disaster_plague_d.png"),
		"hover": preload("res://Assets/UI/Icons/Widgets/Messages/msg_disaster_plague_h.png")
	},
	{	# Letter
		"normal": preload("res://Assets/UI/Icons/Widgets/Messages/msg_letter.png"),
		"pressed": preload("res://Assets/UI/Icons/Widgets/Messages/msg_letter_d.png"),
		"hover": preload("res://Assets/UI/Icons/Widgets/Messages/msg_letter_h.png")
	},
	{	# Money
		"normal": preload("res://Assets/UI/Icons/Widgets/Messages/msg_money.png"),
		"pressed": preload("res://Assets/UI/Icons/Widgets/Messages/msg_money_d.png"),
		"hover": preload("res://Assets/UI/Icons/Widgets/Messages/msg_money_h.png")
	},
	{	# Save
		"normal": preload("res://Assets/UI/Icons/Widgets/Messages/msg_save.png"),
		"pressed": preload("res://Assets/UI/Icons/Widgets/Messages/msg_save_d.png"),
		"hover": preload("res://Assets/UI/Icons/Widgets/Messages/msg_save_h.png")
	},
	{	# System
		"normal": preload("res://Assets/UI/Icons/Widgets/Messages/msg_system.png"),
		"pressed": preload("res://Assets/UI/Icons/Widgets/Messages/msg_system_d.png"),
		"hover": preload("res://Assets/UI/Icons/Widgets/Messages/msg_system_h.png")
	}
]

# Keep this alphabetically ordered
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

func set_message_type(new_message_type: int) -> void:
	message_type = new_message_type

	texture_normal = MESSAGE_TEXTURES[message_type]["normal"]
	texture_pressed = MESSAGE_TEXTURES[message_type]["pressed"]
	texture_hover = MESSAGE_TEXTURES[message_type]["hover"]
