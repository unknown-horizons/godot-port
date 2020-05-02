extends GridContainer

func _ready():
	$NameEdit.text = Global.player_name
	# add language from Global
	var idx = 0
	var i = 0
	for n in Global._lang_array:
		$LanguageEdit.add_item(Global._languages[n])
		if n == Global.language:
			idx = i
		i += 1
	$LanguageEdit.text = Global._languages[Global.language]
	$LanguageEdit.select(idx)
	idx = 0
	i = 0
	for x in Global._screen_res:
		$ResolutionEdit.add_item(x)
		if x == Global.screen_res:
			idx = i
		i += 1
	$ResolutionEdit.select(idx)

func _on_NameEdit_text_entered(new_text):
	Global.player_name = new_text

func _on_LanguageEdit_item_selected(id):
	var lang = Global._lang_array[id]
	Global.language = lang

func _on_ResolutionEdit_item_selected(id):
	var res = Global._screen_res[id]
	Global.screen_res = res
