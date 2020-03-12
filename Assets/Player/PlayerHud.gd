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

func _process(_delta):
	pass
	
func _input(event: InputEvent) -> void:
	_on_input(event)
	
func _on_input(event):
	var selected_units = get_tree().get_nodes_in_group("selected_units")
	if selected_units.size() == 0:
		# should in the future hide all unit-related HUD-Elements
		$MarginContainer/HBoxContainer/ShipMenuTabWidget.visible = false
	elif selected_units.size() == 1: 
		# only one Unit, so probably only possible to build etc. if only one Unit selected
		if selected_units[0].get_groups().find("ships") == 1: # Its a ship
			$MarginContainer/HBoxContainer/ShipMenuTabWidget.visible = true
		if selected_units[0].get_groups().find("ships") != 1: # Its not a ship. Do something else
			pass
	elif selected_units.size() > 1: # multiple units selected, do something else
		pass
	

func raise_notification(message_type, message_text):
	var _debug_message = _debug_messages[randi() % _debug_messages.size()]
	
	if messages.get_child_count() < 6:
		var message = Global.MESSAGE_SCENE.instance()
		
		message.message_type = _debug_message[0]#message_type
		message.message_text = _debug_message[1]#message_text
		messages.add_child(message)
#	else:
#		queued_messages.append()
