extends Resource

class_name GameStatsResource

const save_path = "user://progress.tres"

var resources: Dictionary[StringName, int] = {
  ResourceConfig.Resources.GOLD: 100000,
  ResourceConfig.Resources.TOOLS: 1000,
  ResourceConfig.Resources.BOARDS: 100,
  ResourceConfig.Resources.FLOUR: 100,
} # resource_name to count

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
