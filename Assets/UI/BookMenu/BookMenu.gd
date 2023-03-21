@icon("res://Editor/book.png")
extends CenterContainer
class_name BookMenu

## The main class to manage menus with pages.
##
## Add [b]BookMenuPage[/b] scenes inside the [code]%Pages[/code]
## [TabContainer] node in order to create multipage interfaces.

## Reference to the Control which opened this menu.
var parent: Control = null

@export var has_delete_button: bool : set = set_has_delete_button
@export var has_cancel_button: bool : set = set_has_cancel_button
@export var has_ok_button: bool = true : set = set_has_ok_button

func _ready() -> void:
	var page_control: Control
	for page in %Pages.get_children():
		if %Pages.get_tab_count() > 1:
			page_control = page.find_child("PageControl")
			page_control.get_node("PrevButton").pressed.connect(Callable(self, "_on_PrevButton_pressed"))
			page_control.get_node("NextButton").pressed.connect(Callable(self, "_on_NextButton_pressed"))

			page_control.visible = true

	%Pages.tab_changed.connect(Callable(self, "_on_Pages_tab_changed"))

	# Force-call to determine initial state of page controls (enabled/disabled)
	%Pages.tab_changed.emit(%Pages.current_tab)

func set_has_delete_button(new_has_delete_button: bool) -> void:
	if not is_inside_tree():
		await self.ready

	has_delete_button = new_has_delete_button

	var callback_function = "_on_DeleteButton_pressed"

	for page in %Pages.get_children():
		var delete_button := page.find_child("DeleteButton") as TextureButton
		if not delete_button.pressed.is_connected(Callable(self, callback_function)):
			delete_button.pressed.connect(Callable(self, callback_function))
		delete_button.visible = has_delete_button

func set_has_cancel_button(new_has_cancel_button: bool) -> void:
	if not is_inside_tree():
		await self.ready

	has_cancel_button = new_has_cancel_button

	var pressed_signal := "pressed"
	var callback_function := "_on_CancelButton_pressed"

	for page in %Pages.get_children():
		# Place CancelButton on
		#	left side for one-paged menus
		#	right side for multi-paged menus
		var cancel_button: TextureButton
		if %Pages.get_child_count() > 1:
			cancel_button = page.find_child("RightPageControls").find_child("CancelButton") as TextureButton
		else:
			cancel_button = page.find_child("CancelButton") as TextureButton
		if not cancel_button.is_connected(pressed_signal, Callable(self, callback_function)):
			cancel_button.connect(pressed_signal, Callable(self, callback_function))
		cancel_button.visible = has_cancel_button


func set_has_ok_button(new_has_ok_button: bool) -> void:
	if not is_inside_tree():
		await self.ready

	has_ok_button = new_has_ok_button

	var pressed_signal := "pressed"
	var callback_function := "_on_OKButton_pressed"

	for page in %Pages.get_children():
		var ok_button := page.find_child("OKButton") as TextureButton
		if not ok_button.is_connected(pressed_signal, Callable(self, callback_function)):
			ok_button.connect("pressed", Callable(self, "_on_OKButton_pressed"))
		ok_button.visible = has_ok_button

func _on_PrevButton_pressed() -> void:
	#prints("_on_PrevButton_pressed", "current_tab:", %Pages.current_tab)

	%Pages.current_tab -= 1
	%Pages.emit_signal("tab_changed", %Pages.current_tab)

func _on_NextButton_pressed() -> void:
	#prints("_on_NextButton_pressed", "current_tab:", %Pages.current_tab)

	%Pages.current_tab += 1
	%Pages.emit_signal("tab_changed", %Pages.current_tab)

func _on_Pages_tab_changed(tab: int) -> void:
	#var tab_count = %Pages.get_tab_count()
	#var current_tab = %Pages.current_tab
	var current_tab_control := %Pages.get_current_tab_control() as Control
	var current_page_control := current_tab_control.find_child("PageControl")

#	if %Pages.get_tab_count() <= 1:
#		page_control.get_node("PrevButton").disabled = true
#		page_control.get_node("NextButton").disabled = true
	current_page_control.get_node("PrevButton").disabled = true
	current_page_control.get_node("NextButton").disabled = true
	if %Pages.get_tab_count() > 1:
		if 0 < tab:
			current_page_control.get_node("PrevButton").disabled = false
		if tab < %Pages.get_tab_count() - 1:
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
