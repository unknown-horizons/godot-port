extends Resource

class_name GameStatsResource

const save_path = "user://progress.tres"

var resources: Dictionary[StringName, int] = {
  ResourceConfig.Resources.GOLD: 100000,
  ResourceConfig.Resources.TOOLS: 1000,
  ResourceConfig.Resources.BOARDS: 100,
  ResourceConfig.Resources.FLOUR: 10,
  ResourceConfig.Resources.BRICKS: 100,
} # resource_name to count

var world_tier: StringName = WorldTiers.Tiers.SAILORS:
  set(value):
    var new_enum_value = WorldTiers.TierEnum.get(value, WorldTiers.TierEnum.SAILORS)
    var current_enum_value = WorldTiers.TierEnum.get(self.world_tier, WorldTiers.TierEnum.SAILORS)
    if new_enum_value < current_enum_value:
      return # don't allow going down tiers
    world_tier = value
    world_tier_changed.emit()

## The maximum number of residents for each tier, ten by default
@export var max_residents_per_tier: Dictionary[StringName, int] = {
  WorldTiers.Tiers.SAILORS    : 2,
  WorldTiers.Tiers.PIONEERS   : 3,
  WorldTiers.Tiers.SETTLERS   : 5,
  WorldTiers.Tiers.CITIZENS   : 8,
  WorldTiers.Tiers.MERCHANTS  : 13,
}

## Called when the world tier changes
signal world_tier_changed
signal resources_changed

func add_resource(resource: StringName, amount: int):
  resources[resource] += amount
  resources_changed.emit()

func set_resource(resource: StringName, amount: int):
  resources[resource] = amount
  resources_changed.emit()

func _init():
  for resource in ResourceConfig.Resources.values():
    if resources.has(resource):
      continue
    resources[resource] = 0

func save_game():
  ResourceSaver.save(self, save_path)

static func load_game():
  if ResourceLoader.exists(save_path):
    return ResourceLoader.load(save_path)
  else:
    return GameStatsResource.new()
