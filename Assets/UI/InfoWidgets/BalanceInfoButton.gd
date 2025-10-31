@tool
extends VBoxContainer

@onready var gold_label: LabelEx = $TextureButton/GoldLabel
@onready var expenses_balance_info_item: BalanceInfoButton = $VBoxContainer/Details/MarginContainer/VBoxContainer/ExpensesBalanceInfoItem
@onready var revenue_balance_info_item: BalanceInfoButton = $VBoxContainer/Details/MarginContainer/VBoxContainer/RevenueBalanceInfoItem
@onready var buy_balance_info_item: BalanceInfoButton = $VBoxContainer/Details/MarginContainer/VBoxContainer/BuyBalanceInfoItem
@onready var sell_balance_info_item: BalanceInfoButton = $VBoxContainer/Details/MarginContainer/VBoxContainer/SellBalanceInfoItem
@onready var total_balance_per_second: BalanceInfoButton = $VBoxContainer/TextureRect3/Balance

@export var show_details: bool:
  set(value):
    if not is_inside_tree():
      await self.ready

    show_details = value
    details.visible = show_details

@onready var details = $VBoxContainer/Details

func _ready() -> void:
  show_details = details.visible

func _on_TextureButton_pressed() -> void:
  self.show_details = !show_details
  self.refresh()

func refresh():
  var treasury = GameStats.treasury
  self.gold_label.text = str(GameStats.game_stats_resource.resources.get(ResourceConfig.Resources.GOLD))
  self.expenses_balance_info_item.balance_value = -treasury.total_cost_per_second
  self.revenue_balance_info_item.balance_value = treasury.total_revenue_per_second
  self.total_balance_per_second.balance_value = treasury.total_balance_per_second
