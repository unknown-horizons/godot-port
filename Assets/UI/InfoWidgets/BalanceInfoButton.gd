@tool
extends VBoxContainer

class_name BalanceInfoButton

@onready var overlays_tab_container: TabContainer = %Overlays
# @onready var finance_overlay: MarginContainer = %FinanceOverlay
@onready var building_cost_label: LabelEx = %BuildingCostLabel

@onready var gold_label: LabelEx = %GoldLabel
@onready var expenses_balance_info_item: BalanceInfoItem = %ExpensesBalanceInfoItem
@onready var revenue_balance_info_item: BalanceInfoItem = %RevenueBalanceInfoItem
@onready var buy_balance_info_item: BalanceInfoItem = %BuyBalanceInfoItem
@onready var sell_balance_info_item: BalanceInfoItem = %SellBalanceInfoItem
@onready var total_balance_per_second: BalanceInfoItem = %Balance
@onready var details = %ShowDetails

@export var show_details: bool:
  set(value):
    if not is_inside_tree():
      await self.ready

    show_details = value
    details.visible = show_details


func _ready() -> void:
  show_details = details.visible

func show_building_cost_overlay(building: StringName) -> void:
  self.overlays_tab_container.current_tab = self.overlays_tab_container.get_tab_idx_from_control(self.building_cost_label)
  var gold_cost: int = BuildingConfig.building_to_cost.get(building, {}).get(ResourceConfig.Resources.GOLD, 0)
  self.building_cost_label.text = "-%s" % gold_cost

func show_normal_overlay() -> void:
  self.overlays_tab_container.current_tab = 0 # set default overlay

func _on_TextureButton_pressed() -> void:
  self.show_details = !show_details
  self.refresh()

func refresh():
  var treasury = GameStats.treasury
  self.gold_label.text = str(GameStats.game_stats_resource.resources.get(ResourceConfig.Resources.GOLD))
  self.expenses_balance_info_item.balance_value = -treasury.total_cost_per_second
  self.revenue_balance_info_item.balance_value = treasury.total_revenue_per_second
  self.total_balance_per_second.balance_value = treasury.total_balance_per_second
