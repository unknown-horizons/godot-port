extends PanelContainer

class_name AllTabs

@onready var tab_container: TabContainer = self.get_node("ScrollContainer/TabContainer")
@onready var tab_switches: VBoxContainer = self.get_node("LeftFloatingPanel/TabSwitches")

func _ready() -> void:
  CamUtils.center_if_no_camera(self)

var node_selected: WorldThing2D = null:
  set(value):
    node_selected = value
    if self.node_selected == null:
      push_error("node selected null and All tabs toggled")
      return
    update_switches()

signal new_node_selected(node: WorldThing2D)

func update_switches() -> void:
  var selectable := self.node_selected.get_node("Selectable") as Selectable

  var tabs_to_display: Dictionary[String, bool] = {} # set of tabs to display (imitated by dict)
  for tab in selectable.tabs:
    tabs_to_display[tab] = true

  for tab_switch in tab_switches.get_children():
    var should_be_visible = tabs_to_display.get(tab_switch.name, false)
    tab_switch.visible = should_be_visible

  var active_tab = selectable.tabs[0]

  var tab_container_node = tab_container.get_node(active_tab)
  if tab_container_node == null:
    push_error("Tab not found for '%s'" % [active_tab])
  else:
    for tab_index in tab_container.get_tab_count():
      if tab_container.get_tab_control(tab_index) == tab_container_node:
        tab_container.current_tab = tab_index
        break

  new_node_selected.emit(self.node_selected)
