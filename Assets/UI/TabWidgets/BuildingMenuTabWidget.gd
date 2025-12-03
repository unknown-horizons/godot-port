extends TabWidget
class_name BuildingMenuTabWidget

@onready var tab_switches: VBoxContainer = $LeftFloatingPanel/TabSwitches
@onready var building_menu_type_switch: TextureButton = $ScrollContainer/BuildingMenuTypeSwitch

func _ready():
  CamUtils.center_if_no_camera(self)
  self._on_BuildingMenuTypeSwitch_toggled(building_menu_type_switch.button_pressed)

  for tab_switch: SwitchTabWidget in self.tab_switches.get_children():
    tab_switch.toggled.connect(func (_toggled): self.update_toggle_states(tab_switch))
  update_toggle_states(self.tab_switches.get_child(0))

var updating_toggle_states := false
func update_toggle_states(tab_switch_on: SwitchTabWidget):
  if updating_toggle_states: # avoid recursion due to tab_switch.toggled signal
    return
  updating_toggle_states = true
  for tab_switch: SwitchTabWidget in self.tab_switches.get_children():
    var should_be_pressed = tab_switch_on == tab_switch
    tab_switch.button_pressed = should_be_pressed
  updating_toggle_states = false

func _on_BuildingMenuTypeSwitch_toggled(toggled_on: bool) -> void:
  var tab_switch_to_toggle: SwitchTabWidget = null
  for tab_switch in tab_switches.get_children():
    var visible = tab_switch.name.begins_with("class_") == toggled_on
    tab_switch.visible = visible
    if visible and tab_switch_to_toggle == null:
      tab_switch_to_toggle = tab_switch
  if tab_switch_to_toggle != null:
    tab_switch_to_toggle.pressed.emit()
