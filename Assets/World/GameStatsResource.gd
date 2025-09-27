extends Resource

class_name GameStatsResource

const save_path = "user://progress.tres"

var resources: Dictionary[ResourceConfig.Resources, int] = {}

func _init():
  for resource in ResourceConfig.Resources.values():
    resources[resource] = 0

func save_game():
  ResourceSaver.save(self, save_path)

static func load_game():
  if ResourceLoader.exists(save_path):
    return ResourceLoader.load(save_path)
  else:
    return GameStatsResource.new()
