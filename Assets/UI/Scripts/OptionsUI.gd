extends Control

var parent = null
onready var playerNameEdit = get_node("CenterContainer/Book/MarginContainer/Pages/Left/NameSelection/PlayerName")
onready var languageEdit = get_node("CenterContainer/Book/MarginContainer/Pages/Left/LanguageSelection/Language")
onready var resolutionEdit = get_node("CenterContainer/Book/MarginContainer/Pages/Left/ResolutionSelection/Language")
var _orig_name
var _orig_language
var _orig_resolution

func _ready():
	# save original values
	_orig_name = Global.player_name
	_orig_language = Global.language
	_orig_resolution = Global.screen_res
	# init GUI
	playerNameEdit.text = Global.player_name
	# add language from Global
	var idx = 0
	var i = 0
	for n in Global._lang_array:
		languageEdit.add_item(Global._languages[n])
		if n == Global.language:
			idx = i
		i += 1
	languageEdit.text = Global._languages[Global.language]
	languageEdit.select(idx)
	idx = 0
	i = 0
	for x in Global._screen_res:
		resolutionEdit.add_item(x)
		if x == Global.screen_res:
			idx = i
		i += 1
	resolutionEdit.select(idx)

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _on_Config_Done():
	parent.visible = true
	queue_free()

func _on_save_config():
	Global.player_name = playerNameEdit.text
	var id = languageEdit.get_selected_id()
	var lang = Global._lang_array[id]
	Global.language = lang
	Global.screen_res = Global._screen_res[resolutionEdit.get_selected_id()]
	_on_Config_Done()

func _on_CloseButton_pressed():
	# revert values
	Global.player_name = _orig_name
	Global.language = _orig_language
	Global.screen_res = _orig_resolution
	_on_Config_Done()
