@tool
extends TextureButton
class_name SwitchTabWidget

## Base class for all widget switch handles.

@export var target_control: Control

@export var texture_active: Texture2D
@onready var _texture_normal := texture_normal

# func get_tab_container() -> TabContainer:
#   if owner is TabWidget:
#     if tab_container == null:
#       tab_container = owner.body.get_node("TabContainer")

#       for switch in get_parent().get_children():
#         switch.tab_container = tab_container
#         Utils.ensure_connected(tab_container.tab_changed, _on_TabContainer_tab_changed)

#   return tab_container

var target_tab_container: TabContainer

func _ready() -> void:
  var node := get_node("../../../TabContainer")
  if node == null:
    push_error("../../../TabContainer not found for SwitchTabWidget for ", self)
    return
  self.target_tab_container = node as TabContainer
  if self.target_tab_container == null:
    push_error("../../../TabContainer is not of type TabContainer for ", self)
    return
  
  if Engine.is_editor_hint():
    return
  
  if self.target_tab_container.get_child_count() != self.get_parent().get_child_count():
    push_error("TabContainer child count does not match SwitchTabWidget count for ", self)
    return

func _pressed() -> void:
  Audio.play_snd_click()

func _on_SwitchTabWidget_pressed() -> void:
  if self.target_control == null && self.target_tab_container == null:
    push_error("SwitchTabWidget target_control and target_tab_container are not set", self)
    return

  if self.target_control == null && self.target_tab_container != null:
    # target_control is not set - use the "by convention" approach:
    # the index of the SwitchTabWidget in its parent is the index of the tab to switch to
    var index := get_parent().get_children().find(self)
    self.target_tab_container.current_tab = index
    return

  # find the tab container:
  var tab_container := target_control.get_parent() as TabContainer
  if tab_container == null:
    push_error("Incorrect target control for SwitchTabWidget:", target_control, ". Parent node must be TabContainer.")
    return

  if tab_container != null:
    for tab_index in tab_container.get_tab_count():
      if tab_container.get_tab_control(tab_index) == target_control:
        tab_container.current_tab = tab_index
        # tab_container.tab_changed.emit(tab_container.current_tab)
      

  # if self.tab_container:
  #   prints("Set page", get_index(), "for", owner.name)
  #   tab_container.current_tab = get_index()
  #   tab_container.tab_changed.emit(tab_container.current_tab)

#func _on_SwitchTabWidget_tab_changed(tab: int) -> void:
#	if self.tab_container:
#		prints("Notify", self.name, "about tab change to", tab_container.current_tab)
#		if tab_container.current_tab == get_index():
#			texture_normal = texture_active
#		else:
#			texture_normal = _texture_normal

# func _on_TabContainer_tab_changed(tab: int) -> void:
#   if tab_container.current_tab == get_index():
#     texture_normal = texture_active
#   else:
#     texture_normal = _texture_normal
