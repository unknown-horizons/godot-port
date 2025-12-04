extends PanelContainer

class_name AllTabs

@onready var tab_container: TabContainer = self.get_node("ScrollContainer/TabContainer")
@onready var tab_switches: VBoxContainer = self.get_node("LeftFloatingPanel/TabSwitches")
@onready var refresh_timer: Timer = $RefreshTimer


func _ready() -> void:
	CamUtils.center_if_no_camera(self)

	# self.visibility_changed.connect(func(): print("AllTabs Visibility changed %s" % [self.visible]))
	tab_container.tab_changed.connect(self.tab_changed)
	self.refresh_timer.timeout.connect(self.refresh_timeout)

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
var selected_node: WorldThing2D = null:
	set(value):
		selected_node = value
		if self.selected_node == null:
			push_error("node selected null and All tabs toggled")
			return
		update_switches()

func tab_changed(_tab_index: int):
	var active_tab_node := tab_container.get_current_tab_control()
	if "selected_node" in active_tab_node:
		active_tab_node.selected_node = self.selected_node
	if "refresh_tab" in active_tab_node:
		active_tab_node.refresh_tab()

	self.refresh_timer.start()

func update_switches() -> void:
	var selectable := self.selected_node.get_node("Selectable") as Selectable

	var tabs_to_display: Dictionary[String, bool] = {} # set of tabs to display (imitated by dict)
	for tab in selectable.tabs:
		tabs_to_display[tab] = true

	for tab_switch in tab_switches.get_children():
		var should_be_visible = tabs_to_display.get(tab_switch.name, false)
		tab_switch.visible = should_be_visible

	var active_tab_name = selectable.tabs[0]

	var active_tab_node = tab_container.get_node(active_tab_name) # match tab node by tab name
	if active_tab_node == null:
		push_error("Tab not found for '%s'" % [active_tab_name])
	else:
		for tab_index in tab_container.get_tab_count():
			if tab_container.get_tab_control(tab_index) == active_tab_node:
				if tab_container.current_tab != tab_index:
					tab_container.current_tab = tab_index
				else:
					self.tab_changed(tab_index)
				break

func refresh_timeout():
	if !self.is_visible_in_tree():
		self.refresh_timer.stop()
		return
	self.refresh()

func refresh():
	var active_tab_node := self.tab_container.get_current_tab_control()
	if active_tab_node.has_method("refresh_tab"):
		active_tab_node.refresh_tab()
