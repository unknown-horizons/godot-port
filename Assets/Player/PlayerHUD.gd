extends Control

onready var balance_info_button = $MarginContainer/HBoxContainer/VBoxContainer/BalanceInfoButton
onready var city_info = $MarginContainer/HBoxContainer/CityInfo
onready var messages = $MarginContainer/HBoxContainer/VBoxContainer/Messages

var queued_messages = []

var _debug_messages = [
	[5, "Your game has been autosaved."],
	[3, "Some of your inhabitants have no access to the main square."],
	[2, "I'm just cleaning up here."],
	[1, "Some of your inhabitants have diarrhea."],
	[6, "A problem has occured. Do you want to send an error report?"],
	[4, "This is a very long text. That much, that it easily takes up to 3 lines. Believe it or not."]
]

func raise_notification(message_type: int, message_text: String) -> void:
	var _debug_message = _debug_messages[randi() % _debug_messages.size()]

	if messages.get_child_count() < 6:
		var message = Global.MESSAGE_SCENE.instance()

		message.message_type = _debug_message[0]#message_type
		message.message_text = _debug_message[1]#message_text
		messages.add_child(message)
#	else:
#		queued_messages.append()

func _gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		print_debug("PlayerHUD: %s" % event.as_text())
