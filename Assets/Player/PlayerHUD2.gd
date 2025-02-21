extends Control

func get_tab_index(tab_container: TabContainer, target_control: Control) -> int:
  var tab_index := -1
  for i in range(tab_container.get_tab_count()):
    var tab_control_i = tab_container.get_tab_control(i)
    if tab_control_i == target_control:
      tab_index = i
      break
  return tab_index

func toggle_tab_widget(tab_widget: Control):
  var tab_container: TabContainer = tab_widget.get_parent();
  var tab_index := get_tab_index(tab_container, tab_widget)
  if tab_container.current_tab == tab_index:
    tab_container.current_tab = 0 # switch off the tabs, by switching to the first tab
  else:
    tab_container.current_tab = tab_index
  

func _input(event: InputEvent) -> void:
  if event.is_action_pressed("toggle_building_menu"):
    toggle_tab_widget(%BuildMenuByCategoryTabWidget);

  if event.is_action_pressed("toggle_diplomacy_menu"):
    push_warning("Diplomacy menu is not implemented yet.")
    # toggle_tab_widget(%BuildMenuByCategoryTabWidget);
  
  if event.is_action_pressed("toggle_building_info_menu"):
    var tab_container: TabContainer = self.get_node("HBoxContainer/VBoxContainer/TabContainer")
    var target_tab_widget_name = event.get_meta("tab_widget_name")
    var selected_objects: Array = event.get_meta("selected_objects")
    for tab_widget in tab_container.get_children():
      var building_menu_tab_widget = tab_widget as BuildingMenuTabWidget
      var ship_menu_tab_widget = tab_widget as ShipMenuTabWidget
      if tab_widget.name == target_tab_widget_name:
        if building_menu_tab_widget:
          building_menu_tab_widget.selected_objects = selected_objects
        if ship_menu_tab_widget:
          ship_menu_tab_widget.selected_objects = selected_objects
        var tab_index := get_tab_index(tab_container, tab_widget)
        tab_container.current_tab = tab_index
        break
