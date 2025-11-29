@tool
extends TextureButton
class_name SwitchTabWidget

## Base class for all widget switch handles.

@export var texture_active: Texture2D

var tab_container: TabContainer

@onready var background_texture_rect: TextureRect = $BackgroundTextureRect

func _ready() -> void:
  if Engine.is_editor_hint():
    return
  CamUtils.center_if_no_camera(self)
  self.mouse_entered.connect(_on_mouse_entered)
  self.mouse_exited.connect(_on_mouse_exited)
  
  self.material = self.material.duplicate()

  if not self.tooltip_text:
    # self.tooltip_text = self.name.to_snake_case().replace("_", " ").trim_suffix(" button")
    self.tooltip_text = self.name.capitalize().trim_suffix(" Button")

  self.tab_container = get_node("../../../ScrollContainer/TabContainer") as TabContainer
  if self.tab_container == null:
    push_error("../../../ScrollContainer/TabContainer is not found or not of type TabContainer for ", self)
    return

func _pressed() -> void:
  Audio.play_snd_click()

func _on_mouse_entered():
  self.material.set_shader_parameter("is_hovered", true)

func _on_mouse_exited():
  self.material.set_shader_parameter("is_hovered", false)

func _on_toggled(toggled_on: bool) -> void:
  self.material.set_shader_parameter("is_active", toggled_on)
  if toggled_on:
    self.background_texture_rect.modulate = Color(1.5, 1.5, 1.5, 1)
  else:
    self.background_texture_rect.modulate = Color(1, 1, 1, 1)

func _on_SwitchTabWidget_pressed() -> void:
  var tab_container_node = self.tab_container.get_node(str(self.name))
  if tab_container_node == null:
    push_error("Tab not found for '%s'" % [self.name])
  else:
    for tab_index in tab_container.get_tab_count():
      if tab_container.get_tab_control(tab_index) == tab_container_node:
        tab_container.current_tab = tab_index
        break
