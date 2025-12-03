extends HBoxContainer

class_name FinanceAndResourceOverlay

@onready var balance_info_button: BalanceInfoButton = %BalanceInfoButton
@onready var resources_overlay: ResourceOverlay = %ResourcesOverlay

var current_context: BaseContext = null

func on_context_changed(context: BaseContext) -> void:
  var building := &""
  var road_building_context := context as BuildingRoadContext
  var building_context := context as BuildingContext
  self.current_context = context

  if road_building_context != null:
    building = &"TRAIL" # trail toggled, set name as trail

  if building_context != null:
    if building_context.building_changed.is_connected(self.on_building_changed) == false:
      building_context.building_changed.connect(self.on_building_changed)
    building = building_context.building_to_build
  else: # if the context is not the building context disconnect the update signal
    var remembered_building_context := self.current_context as BuildingContext
    if remembered_building_context != null and remembered_building_context.building_changed.is_connected(self.on_building_changed):
      remembered_building_context.building_changed.disconnect(self.on_building_changed)

  if building != &"":
    balance_info_button.show_building_cost_overlay(building)
    resources_overlay.show_building_cost_overlay(building)
  else: # if there is no building(other context was set) toggle default overlays
    balance_info_button.show_normal_overlay()
    resources_overlay.show_normal_overlay()
    return

func on_building_changed(building: StringName) -> void:
  self.balance_info_button.show_building_cost_overlay(building)
  self.resources_overlay.show_building_cost_overlay(building)
