@tool
extends TextureButton
class_name SwitchTabWidget

## Base class for all widget switch handles.

@export var texture_active: Texture2D
@onready var _texture_normal := texture_normal

@onready var tab_container: TabContainer : get = get_tab_container

#func _ready() -> void:
#	if not Engine.is_editor_hint():
#		if get_index() == 0: # => every other switch node is ready
#			for sibling in get_parent().get_children():
#				sibling._listen_to_other_switches()
#
#func _listen_to_other_switches() -> void:
#	for sibling in get_parent().get_children():
#		sibling.tab_changed.connect(Callable(self, "_on_SwitchTabWidget_tab_changed"))

func _draw() -> void:
#	if texture_normal:
#		custom_minimum_size = texture_normal.get_size()
#	else:
#		custom_minimum_size = size
	custom_minimum_size.y = 46

	notify_property_list_changed()

func get_tab_container() -> TabContainer:
	if owner is TabWidget:
		if tab_container == null:
			tab_container = owner.body.get_node("TabContainer")

			for switch in get_parent().get_children():
				switch.tab_container = tab_container
				if !tab_container.tab_changed.is_connected(Callable(switch, "_on_TabContainer_tab_changed")):
					tab_container.tab_changed.connect(Callable(switch, "_on_TabContainer_tab_changed"))

	return tab_container

func _pressed() -> void:
	Audio.play_snd_click()

func _on_SwitchTabWidget_pressed() -> void:
	if self.tab_container:
		prints("Set page", get_index(), "for", owner.name)
		tab_container.current_tab = get_index()
		tab_container.emit_signal("tab_changed", tab_container.current_tab)

#func _on_SwitchTabWidget_tab_changed(tab: int) -> void:
#	if self.tab_container:
#		prints("Notify", self.name, "about tab change to", tab_container.current_tab)
#		if tab_container.current_tab == get_index():
#			texture_normal = texture_active
#		else:
#			texture_normal = _texture_normal

func _on_TabContainer_tab_changed(tab: int) -> void:
	if tab_container.current_tab == get_index():
		texture_normal = texture_active
	else:
		texture_normal = _texture_normal
