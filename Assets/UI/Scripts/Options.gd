extends Control

var parent = null

var _options = {
	graphics = preload("res://Assets/UI/Scenes/OptionsGraphics.tscn"),
	hotkeys = preload("res://Assets/UI/Scenes/OptionsDummy.tscn"),
	game = preload("res://Assets/UI/Scenes/OptionsDummy.tscn")
}

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _on_Button_Signal(option_name):
	var node = get_node("CenterContainer/TextureRect/MarginContainer/HBoxContainer/VBoxContainer/OptionsContainer")
	delete_children(node)
	node.add_child(_options[option_name].instance())
	
func _on_Config_Done():
	parent.visible = true
	queue_free()
