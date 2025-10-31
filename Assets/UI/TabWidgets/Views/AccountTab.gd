extends VBoxContainer

@onready var gold_label: LabelEx = %GoldLabel
@onready var taxes_label: LabelEx = %TaxesLabel
@onready var sale_label: LabelEx = %SaleLabel
@onready var running_costs_label: LabelEx = %RunningCostsLabel
@onready var buying_label: LabelEx = %BuyingLabel
@onready var balance_label: LabelEx = %BalanceLabel

var selected_node: WorldThing2D = null:
  set(value):
    selected_node = value
    on_new_selected_node(value)

func on_new_selected_node(node: WorldThing2D) -> void:
  for child in self.get_children():
    if "selected_node" in child:
      child.selected_node = node

func refresh_tab():
  self.gold_label.text = str(GameStats.game_stats_resource.resources.get(ResourceConfig.Resources.GOLD))
  self.taxes_label.text = str(GameStats.treasury.total_revenue_per_second)
  self.sale_label.text = str(0) # TODO
  self.running_costs_label.text = str(GameStats.treasury.total_cost_per_second)
  self.buying_label.text = str(0) # TODO
  self.balance_label.text = str(GameStats.treasury.total_balance_per_second)
