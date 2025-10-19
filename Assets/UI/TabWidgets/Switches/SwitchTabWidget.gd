@tool
extends TextureButton
class_name SwitchTabWidget

## Base class for all widget switch handles.

@export var texture_active: Texture2D

var tab_container: TabContainer

func _ready() -> void:
  if Engine.is_editor_hint():
    return
  self.tab_container = get_node("../../../ScrollContainer/TabContainer") as TabContainer
  if self.tab_container == null:
    push_error("../../../ScrollContainer/TabContainer is not found or not of type TabContainer for ", self)
    return

func _pressed() -> void:
  Audio.play_snd_click()

func _on_SwitchTabWidget_pressed() -> void:
  var tab_container_node = self.tab_container.get_node(str(self.name))
  if tab_container_node == null:
    push_error("Tab not found for '%s'" % [self.name])
  else:
    for tab_index in tab_container.get_tab_count():
      if tab_container.get_tab_control(tab_index) == tab_container_node:
        tab_container.current_tab = tab_index
        break
