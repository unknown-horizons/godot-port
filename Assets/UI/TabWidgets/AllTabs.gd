extends PanelContainer

class_name AllTabs

@onready var tab_container: TabContainer = self.get_node("ScrollContainer/TabContainer")
@onready var tab_switches: VBoxContainer = self.get_node("LeftFloatingPanel/TabSwitches")

func _ready() -> void:
  CamUtils.center_if_no_camera(self)

var tabs: Array[String] = []:
  set(value):
    tabs = value
    update_switches()

var node_selected: WorldThing2D = null:
  set(value):
    node_selected = value
    if self.node_selected == null:
      push_error("node selected null and All tabs toggled")
      return
    update_switches()

signal new_node_selected(node: WorldThing2D)

func update_switches() -> void:
  var building: Building2D = self.node_selected as Building2D
  # building
  if building != null:
    # The firts tab in the needed tabs, to open it at the beginning
    var first_available_tab_index: int = len(self.tabs)
    var first_available_tab: Control = null
    # go over all switches and toggle visible if tab in the building's tabs
    for child in tab_switches.get_children():
      var tab_switch: SwitchTabWidget = child as SwitchTabWidget
      if tab_switch != null:
        if tab_switch.target_control == null: # if not used, turn of
          tab_switch.visible = false
          push_warning("SwitchTabWidget target_control is not set", tab_switch)
          continue
        # find tab switch in the building's tabs and set visible if found
        var name: String = tab_switch.target_control.name
        var matching_name_index: int = self.get_matching_name_index(name, self.tabs)
        tab_switch.visible = matching_name_index != -1
        # check if the first available tab
        if matching_name_index != -1 and first_available_tab_index > matching_name_index:
          first_available_tab_index = matching_name_index
          first_available_tab = tab_switch.target_control
    # set the current tab, first in needed tabs, if not found: empty
    if first_available_tab != null:
      self.tab_container.current_tab = self.tab_container.get_children().find(first_available_tab)
    else:
      self.tab_container.current_tab = 0
  new_node_selected.emit(self.node_selected)


## returns the first index of the string in the array that has is a substring of name or contains it
func get_matching_name_index(name: String, names: Array[String]) -> int:
  for i in range(len(names)):
    var potential_match: String = names[i]
    if name in potential_match or potential_match in name:
      return i
  return -1
