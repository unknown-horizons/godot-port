@tool

extends Building2D

class_name Residential

## The range within which the residents_count of this building are stable(not increasing or decreasing)
@export var stable_residents_count_range: Vector2 = Vector2(30, 70)
## The range within which the tier of this building is stable(not increasing or decreasing)
@export var stable_tier_range: Vector2 = Vector2(10, 80)

var max_residents_for_current_tier: int:
  get():
    return GameStats.game_stats_resource.max_residents_per_tier.get(self.current_tier, 10)

@export var happiness_usage_per_inhabitant: int = 20
@export var happiness_usage_per_tier: int = 40

@export var happiness_usage_per_second: float = 1.0

## emitted when the number of residents_count of this building changes
signal residents_count_changed(residents_count: int)

var residents_count: int = 1:
  set(value):
    var previous_residents_count := self.residents_count
    residents_count = clampi(value, 1, self.max_residents_for_current_tier)
    
    if Engine.is_editor_hint():
      return

    self.spend_happiness((residents_count - previous_residents_count) * self.happiness_usage_per_inhabitant)
    
    self.residents_count_changed.emit(self.residents_count)

func set_current_tier(new_tier: StringName) -> void:
  var previous_tier := self.current_tier
  current_tier = new_tier
  var current_enum_tier: WorldTiers.TierEnum = WorldTiers.TierEnum.get(self.current_tier, WorldTiers.TierEnum.SAILORS)
  # notify children
  for node: Node in self.get_children():
    if "current_tier" in node:
      if node.current_tier is StringName: # if uses StringName
        node.current_tier = self.current_tier
      elif node.current_tier is WorldTiers.TierEnum: # if uses enum
        node.current_tier = current_enum_tier
  
  # spend/gain happiness from upgarde/downgrade
  var previous_enum_tier: WorldTiers.TierEnum = WorldTiers.TierEnum.get(previous_tier, WorldTiers.TierEnum.SAILORS)
  self.spend_happiness((current_enum_tier - previous_enum_tier) * self.happiness_usage_per_tier)
  # update world tier
  var world_enum_tier: WorldTiers.TierEnum = WorldTiers.TierEnum.get(GameStats.game_stats_resource.world_tier, WorldTiers.TierEnum.SAILORS)
  if world_enum_tier < current_enum_tier:
    GameStats.game_stats_resource.world_tier = self.current_tier

  self.refresh_resources_produced_consumed()

func connect_set_tier() -> void:
  # listen to storage changes and do not listen to world tier
  for storage: StorageComponent in self.get_all_nodes_of_type(StorageComponent):
    storage.storage_changed.connect(self.update_tier.unbind(1))

func refresh_resources_produced_consumed():
  # an override to consume happiness always
  super()
  self.resources_produced.erase(ResourceConfig.Resources.HAPPINESS)
  self.resources_consumed[ResourceConfig.Resources.HAPPINESS] = true

func get_happiness() -> int:
  var happiness := 0
  var storages: Array = self.get_all_nodes_of_type(StorageComponent)
  for storage: StorageComponent in storages:
    happiness += storage.get_storage_item_amount(ResourceConfig.Resources.HAPPINESS)
  return happiness

func update_tier() -> void:
  # calculate happiness
  var happiness := self.get_happiness()
  # print("    residents_count: %s |     tier: %s |     happiness: %s" % [self.residents_count, self.current_tier, happiness])

  # set residents_count
  # -1 if decreasing, 0 if stable, 1 if increasing
  var residents_count_change := signi(happiness - clamp(happiness, self.stable_residents_count_range.x, self.stable_residents_count_range.y))
  var last_residents_count := self.residents_count
  self.residents_count += residents_count_change
  if last_residents_count != self.residents_count:
    return # increase residents_count first
  
  # set tier
  # -1 if downgrading, 0 if stable, 1 if upgrading
  var tier_change := signi(happiness - clamp(happiness, self.stable_tier_range.x, self.stable_tier_range.y))
  var enum_tier: WorldTiers.TierEnum = WorldTiers.TierEnum.get(self.current_tier, WorldTiers.TierEnum.SAILORS)
  var new_enum_tier := clampi(enum_tier + tier_change, WorldTiers.TierEnum.SAILORS, WorldTiers.TierEnum.MERCHANTS)
  var new_tier: StringName = WorldTiers.TierEnum.find_key(new_enum_tier)
  if new_tier != self.current_tier:
    self.current_tier = new_tier
  
  # # log default
  # print("New residents_count: %s | New tier: %s | New happiness: %s" % [self.residents_count, self.current_tier, 
  # self.get_first_node_of_type(StorageComponent).get_storage_item_amount(ResourceConfig.Resources.HAPPINESS)])

## goes across all storages trying to spend the given amount of happiness
func spend_happiness(happiness_to_spend: int):
  var storages := self.get_all_nodes_of_type(StorageComponent)
  var i := 0
  while abs(happiness_to_spend) > 0:
    if i >= len(storages):
      break
    var storage: StorageComponent = storages[i]
    var happiness_in_storage: int = storage.get_storage_item_amount(ResourceConfig.Resources.HAPPINESS)
    var happiness_to_take_or_give := mini(happiness_to_spend, happiness_in_storage)
    storage.set_storage_item_amount(ResourceConfig.Resources.HAPPINESS, happiness_in_storage - happiness_to_take_or_give)
    happiness_to_spend -= happiness_to_take_or_give
    i += 1

## The happiness left to pay from previous tax collections
var happiness_to_pay: float = 0

## Collects taxes and returns the tax revenue, reduces happiness
func collect_taxes_and_pay_hapinness(delta_time: float) -> float:
  var tax_rate := GameStats.treasury.tax_rate_per_tier[self.current_tier_val]
  self.happiness_to_pay += self.happiness_usage_per_second * delta_time * tax_rate
  var happiness_can_be_paid := int(self.happiness_to_pay)
  if happiness_can_be_paid != 0: # spend happiness if can be spent as int
    self.spend_happiness(happiness_can_be_paid)
    self.happiness_to_pay -= happiness_can_be_paid
  # calculate tax revenue
  var tax_revenue := self.calculate_tax_revenue_per_second() * delta_time
  return tax_revenue

## Returns the tax revenue(use to calculate revenue, not a real pay tax with happiness reduction)
func calculate_tax_revenue_per_second() -> float:
  var gold_per_resident_per_second := GameStats.treasury.gold_per_resident_per_tier_per_second[self.current_tier]
  var tax_revenue = self.residents_count * GameStats.treasury.tax_rate_per_tier[self.current_tier_val] * gold_per_resident_per_second
  return tax_revenue
