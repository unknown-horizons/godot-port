extends Resource

class_name Treasury

var tax_rate_per_tier: Dictionary[WorldTiers.TierEnum, float] = {
  WorldTiers.TierEnum.SAILORS: 1.0,
  WorldTiers.TierEnum.PIONEERS: 1.0,
  WorldTiers.TierEnum.SETTLERS: 1.0,
  WorldTiers.TierEnum.CITIZENS: 1.0,
  WorldTiers.TierEnum.MERCHANTS: 1.0,
}

# stats per second
var total_cost_per_second: float = 0.0
var total_revenue_per_second: float = 0.

var total_balance_per_second: float = 0.0

var gold_per_person_per_second: float = 2.0

var revenue_per_tier_per_second: Dictionary[WorldTiers.TierEnum, float] = {}

func _on_treasury_timer_timeout(timer: Timer):
  var total_cost = 0.0
  var total_revenue = 0.0
  var buildings := timer.get_tree().get_nodes_in_group("Buildings")
  var revenue_per_tier: Dictionary[WorldTiers.TierEnum, float] = {}
  for building: Building2D in buildings:
    var residence := building as Residential
    if residence != null:
      if not building.paused:
        var residence_revenue = residence.calculate_tax_revenue()
        total_revenue += residence_revenue
        revenue_per_tier[residence.current_tier_val] = revenue_per_tier.get(residence.current_tier_val, 0.0) + residence_revenue
    total_cost += building.cost if not building.paused else building.cost_inactive
  GameStats.game_stats_resource.resources[ResourceConfig.Resources.GOLD] += int(total_revenue - total_cost)

  self.total_cost_per_second = total_cost / timer.wait_time
  self.total_revenue_per_second = total_revenue / timer.wait_time

  self.total_balance_per_second = (total_revenue - total_cost) / timer.wait_time

  for revenue in revenue_per_tier:
    revenue_per_tier[revenue] /= timer.wait_time
  self.revenue_per_tier_per_second = revenue_per_tier
