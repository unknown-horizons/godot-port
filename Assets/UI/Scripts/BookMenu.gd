extends CenterContainer
class_name BookMenu

#signal tab_index_changed

# warning-ignore:unused_class_variable
var parent = null

export(bool) var has_delete_button setget set_has_delete_button
export(bool) var has_cancel_button setget set_has_cancel_button
export(bool) var has_ok_button := true setget set_has_ok_button

onready var pages := $Pages as TabContainer

func _ready() -> void:
	var page_control
	for page in pages.get_children():
		if pages.get_tab_count() > 1:
			page_control = page.find_node("PageControl")
			page_control.get_node("PrevButton").connect("pressed", self, "_on_PrevButton_pressed")
			page_control.get_node("NextButton").connect("pressed", self, "_on_NextButton_pressed")

			page_control.visible = true

	# warning-ignore:return_value_discarded
	#connect("tab_index_changed", self, "_on_Pages_tab_changed")
	pages.connect("tab_changed", self, "_on_Pages_tab_changed")

	# Force-call to determine initial state of page controls (enabled/disabled)
	pages.emit_signal("tab_changed", pages.current_tab)

func set_has_delete_button(new_has_delete_button: bool) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	has_delete_button = new_has_delete_button

	var pressed_signal = "pressed"
	var callback_function = "_on_DeleteButton_pressed"

	for page in pages.get_children():
		var delete_button = page.find_node("DeleteButton")
		if not delete_button.is_connected(pressed_signal, self, callback_function):
			# warning-ignore:return_value_discarded
			delete_button.connect(pressed_signal, self, callback_function)
		delete_button.visible = has_delete_button

func set_has_cancel_button(new_has_cancel_button: bool) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	has_cancel_button = new_has_cancel_button

	var pressed_signal = "pressed"
	var callback_function = "_on_CancelButton_pressed"

	for page in pages.get_children():
		# Place CancelButton on
		#	left side for one-paged menus
		#	right side for multi-paged menus
		var cancel_button
		if pages.get_child_count() > 1:
			cancel_button = page.find_node("RightPage").find_node("CancelButton")
		else:
			cancel_button = page.find_node("CancelButton")
		if not cancel_button.is_connected(pressed_signal, self, callback_function):
			# warning-ignore:return_value_discarded
			cancel_button.connect(pressed_signal, self, callback_function)
		cancel_button.visible = has_cancel_button


func set_has_ok_button(new_has_ok_button: bool) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	has_ok_button = new_has_ok_button

	var pressed_signal = "pressed"
	var callback_function = "_on_OKButton_pressed"

	for page in pages.get_children():
		var ok_button = page.find_node("OKButton")
		if not ok_button.is_connected(pressed_signal, self, callback_function):
			# warning-ignore:return_value_discarded
			ok_button.connect("pressed", self, "_on_OKButton_pressed")
		ok_button.visible = has_ok_button

func _on_PrevButton_pressed() -> void:
	#prints("_on_PrevButton_pressed", "current_tab:", pages.current_tab)
	Audio.play_snd_click()

	pages.current_tab -= 1
	#emit_signal("tab_index_changed")
	pages.emit_signal("tab_changed", pages.current_tab)

func _on_NextButton_pressed() -> void:
	#prints("_on_NextButton_pressed", "current_tab:", pages.current_tab)
	Audio.play_snd_click()

	pages.current_tab += 1
	#emit_signal("tab_index_changed")
	pages.emit_signal("tab_changed", pages.current_tab)

func _on_Pages_tab_changed(tab: int) -> void:
	#var tab_count = pages.get_tab_count()
	#var current_tab = pages.current_tab
	var current_tab_control = pages.get_current_tab_control()
	var current_page_control = current_tab_control.find_node("PageControl")

#	if pages.get_tab_count() <= 1:
#		page_control.get_node("PrevButton").disabled = true
#		page_control.get_node("NextButton").disabled = true
	current_page_control.get_node("PrevButton").disabled = true
	current_page_control.get_node("NextButton").disabled = true
	if pages.get_tab_count() > 1:
		if 0 < tab:
			current_page_control.get_node("PrevButton").disabled = false
		if tab < pages.get_tab_count() - 1:
			current_page_control.get_node("NextButton").disabled = false

func _on_DeleteButton_pressed() -> void:
	#print("_on_DeleteButton_pressed")
	Audio.play_snd_click()

func _on_CancelButton_pressed() -> void:
	#print("_on_CancelButton_pressed")
	Audio.play_snd_click()

	if parent != null:
		parent.visible = true
	queue_free()

func _on_OKButton_pressed() -> void:
	#print("_on_OKButton_pressed")
	Audio.play_snd_click()

	if parent != null:
		parent.visible = true
	queue_free()

func _on_ready() -> void:
	if not pages: pages = $Pages
