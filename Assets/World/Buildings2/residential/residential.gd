extends Building2D

class_name Residential

## The range within which the residence of this building are stable(not increasing or decreasing)
@export var stable_residence_range: Vector2 = Vector2(30, 70)
## The range within which the tier of this building is stable(not increasing or decreasing)
@export var stable_tier_range: Vector2 = Vector2(10, 80)

var max_residents_for_current_tier: int:
  get():
    return GameStats.game_stats_resource.max_residents_per_tier.get(self.current_tier, 10)

@export var happiness_usage_per_inhabitant: int = 20
@export var happiness_usage_per_tier: int = 40

## emitted when the number of residence of this building changes
signal residence_changed(residence: int)

var residence: int = 1:
  set(value):
    var previous_residence := self.residence
    residence = clampi(value, 1, self.max_residents_for_current_tier)

    self.spend_happiness((residence - previous_residence) * self.happiness_usage_per_inhabitant)
    
    self.residence_changed.emit(self.residence)

func _on_tier_changed() -> void:
  var previous_enum_tier: WorldTiers.TierEnum = WorldTiers.TierEnum.get(self.current_tier, WorldTiers.TierEnum.SAILORS)
  var current_enum_tier: WorldTiers.TierEnum = WorldTiers.TierEnum.get(self.current_tier, WorldTiers.TierEnum.SAILORS)
  # notify children
  for node: Node in self.get_children():
    if "current_tier" in node:
      if node.current_tier is StringName: # if uses StringName
        node.current_tier = self.current_tier
      elif node.current_tier is WorldTiers.TierEnum: # if uses enum
        node.current_tier = current_enum_tier
  
  # spend/gain happiness from upgarde/downgrade
  self.spend_happiness((current_enum_tier - previous_enum_tier) * self.happiness_usage_per_tier)
  # update world tier
  var world_enum_tier: WorldTiers.TierEnum = WorldTiers.TierEnum.get(GameStats.game_stats_resource.world_tier, WorldTiers.TierEnum.SAILORS)
  if world_enum_tier < current_enum_tier:
    GameStats.game_stats_resource.world_tier = self.current_tier

func connect_set_tier() -> void:
  # listen to storage changes and do not listen to world tier
  for storage: StorageComponent in self.get_all_nodes_of_type(StorageComponent):
    storage.storage_changed.connect(self.update_tier.unbind(1))

func get_happiness() -> int:
  var happiness := 0
  var storages: Array = self.get_all_nodes_of_type(StorageComponent)
  for storage: StorageComponent in storages:
    happiness += storage.get_storage_item_amount(ResourceConfig.Resources.HAPPINESS)
  return happiness

func update_tier() -> void:
  # calculate happiness
  var happiness := self.get_happiness()
  # print("    residence: %s |     tier: %s |     happiness: %s" % [self.residence, self.current_tier, happiness])

  # set residence
  # -1 if decreasing, 0 if stable, 1 if increasing
  var residence_change := signi(happiness - clamp(happiness, self.stable_residence_range.x, self.stable_residence_range.y))
  var last_residence := self.residence
  self.residence += residence_change
  if last_residence != self.residence:
    return # increase residence first
  
  # set tier
  # -1 if downgrading, 0 if stable, 1 if upgrading
  var tier_change := signi(happiness - clamp(happiness, self.stable_tier_range.x, self.stable_tier_range.y))
  var enum_tier: WorldTiers.TierEnum = WorldTiers.TierEnum.get(self.current_tier, WorldTiers.TierEnum.SAILORS)
  var new_enum_tier := clampi(enum_tier + tier_change, WorldTiers.TierEnum.SAILORS, WorldTiers.TierEnum.MERCHANTS)
  var new_tier: StringName = WorldTiers.TierEnum.find_key(new_enum_tier)
  self.current_tier = new_tier
  
  # # log default
  # print("New residence: %s | New tier: %s | New happiness: %s" % [self.residence, self.current_tier, 
  # self.get_first_node_of_type(StorageComponent).get_storage_item_amount(ResourceConfig.Resources.HAPPINESS)])

## goes across all storages trying to spend the given amount of happiness
func spend_happiness(happiness_to_spend: int):
  var storages := self.get_all_nodes_of_type(StorageComponent)
  var i := 0
  while abs(happiness_to_spend) > 0:
    if i >= len(storages):
      push_error("trying to increase residence but not enough happiness in storages")
      break
    var storage: StorageComponent = storages[i]
    var happiness_in_storage: int = storage.get_storage_item_amount(ResourceConfig.Resources.HAPPINESS)
    var happiness_to_take_or_give := mini(happiness_to_spend, happiness_in_storage)
    storage.set_storage_item_amount(ResourceConfig.Resources.HAPPINESS, happiness_in_storage - happiness_to_take_or_give)
    happiness_to_spend -= happiness_to_take_or_give
