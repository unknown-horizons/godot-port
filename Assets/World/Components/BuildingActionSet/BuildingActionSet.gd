@tool

extends BaseComponent
## The action set component is used in buildings to determine the image and more.
## Important: The animation will be determined by "{tier_prefix}{base_prefix}{Angle}", with the tier_prefix being a lowercase tier name.

class_name BuildingActionSet

@export var cannot_build_material: ShaderMaterial = preload("res://Assets/World/Tilemaps/Highlight/CannotBuildMaterial.tres")

## The sprite frames for the image of the building
@export var sprite_frames: SpriteFrames = null:
  set(value):
    sprite_frames = value
    if animated_sprite == null:
      return
    animated_sprite.sprite_frames = sprite_frames
    if sprite_frames == null:
      push_warning("No sprite frames assigned")
    update_animation()

enum Orientations {
  _045 = 45,
  _135 = 135,
  _225 = 225,
  _315 = 315
}

## The rotation of the building, used to determine the animation
@export var orientation: Orientations = Orientations._045:
  set(value):
    orientation = value
    update_animation()

## The current world's tier
@export var current_world_tier: ActionSetEnum.Tiers = ActionSetEnum.Tiers.MAX:
  set(value):
    current_world_tier = value
    if self.per_tier_animation_names.size() > 0 and self.per_tier_animation_names[current_world_tier].size() > 0:
      self.current_as_name = self.per_tier_animation_names[current_world_tier][0].split(".")[0] # TODO: pick random as_name
    update_animation()

# @export # no need to export - there is a custom one @ _get_property_list
var current_as_name: String = "":
  set(value):
    current_as_name = value
    update_animation()

@onready var animated_sprite: AnimatedSprite2D = self.get_node("AnimatedSprite2D")

## The current state of the building, used to determine the animation
@export var building_state: BuildingStates = BuildingStates.IDLE:
  set(value):
    if building_state != value:
      building_state = value
      update_animation()

## The possible states of the building
enum BuildingStates{
  ## The building is in its idle state
  IDLE,
  ## The building is in its active state
  WORK,
}

func get_action_set_names():
  var animation_names := self.sprite_frames.get_animation_names()
  var as_names := {}
  for name in animation_names:
    var prefix = name.split(".")[0]
    as_names[prefix] = true  # using keys to simulate a set
  return as_names

#region Editor: dynamic values for dropdown for `current_as_name`
func _get_property_list() -> Array:
  # adds additional properties to export list. It is used to provide a dynamic values for the `current_as_name` drop down
  # print("_get_property_list!")
  return [
    # {
    #   name = "Outline",
    #   type = TYPE_NIL,
    #   hint_string = "Outline_",
    #   usage = PROPERTY_USAGE_GROUP
    # },
    {
      "name": "current_as_name",
      "type": TYPE_STRING,
      "hint": PROPERTY_HINT_ENUM,
      "hint_string": ",".join(self.get_action_set_names().keys()),
      "usage": PROPERTY_USAGE_DEFAULT,
    }
  ]

func _get(property_name):
  if property_name == "current_as_name":
    # print("_get: ", property_name)
    return self.current_as_name

func _set(property_name, val):
  if property_name == "current_as_name":
    # print("_set: ", property_name)
    self.current_as_name = val
#endregion

var per_tier_animation_names: Array[Array] = []

func _ready():
  if self.animated_sprite:
    self.animated_sprite.sprite_frames = sprite_frames

  # initialize the per_tier_animation_names from self.sprite_frames.get_animation_names()
  per_tier_animation_names.resize(ActionSetEnum.Tiers.MAX+1)

  for animation_name in self.sprite_frames.get_animation_names():
    var parts = animation_name.split(".")
    if parts.size() < 2:
      push_error("Unknown animation_name: %s" % animation_name)
      continue  # skip malformed
    var animation_tier_name = parts[1].to_upper()  # e.g. "MERCHANTS"
    if ActionSetEnum.Tiers.has(animation_tier_name):
      var tier_enum = ActionSetEnum.Tiers[animation_tier_name]
      per_tier_animation_names[tier_enum].push_back(animation_name)
    else:
      push_error("Unknown tier: %s" % animation_tier_name)

    if self.per_tier_animation_names.size() > 0 and self.per_tier_animation_names[current_world_tier].size() > 0:
      self.current_as_name = self.per_tier_animation_names[current_world_tier][0].split(".")[0] # TODO: pick random as_name

  update_animation()

func update_animation() -> void:
  # if the sprite frames or the animated sprite is null then return because there is nothing to update
  if animated_sprite == null or sprite_frames == null:
    return
  
  var orientation_str: String = str(snappedi(self.orientation+45, 90)-45).pad_zeros(3) # get the rotation as string
  # get the state as string
  var state_str: String = BuildingStates.find_key(building_state).to_lower()

  # get the last tier before the current at which we have an animation, as string
  var animation_name: String = ""

  for tier in range(self.current_world_tier, ActionSetEnum.Tiers.MIN+1-1, -1): # start with current_world_tier and go backwards
    var tier_name_lc: String = ActionSetEnum.Tiers.keys()[tier].to_lower() # the tier as a lowercase string
    var tier_animations = self.per_tier_animation_names[tier]
    if tier_animations.size() > 0: # if the tier contains any animations - we choose one from them
      var as_animations = tier_animations.filter(func(k): return k.contains(self.current_as_name))
      if as_animations.size() > 0: # if actionset_name animation present - choose only from animations corresponding to the actionset_name
        tier_animations = as_animations
      var orientation_animations = tier_animations.filter(func(k): return k.contains(orientation_str))
      if orientation_animations.size() > 0: # if orientation animation present - choose only from the animations corresponding to the orientation
        tier_animations = orientation_animations

      var working_state_animations = tier_animations.filter(func(k): return k.contains(state_str)) # lease priority for filtering
      if working_state_animations.size() > 0: # if working state animation present - choose only from the animations corresponding to the working state
        tier_animations = working_state_animations
      
      if tier_animations.size() > 1:
        push_error("Multiple animations found for tier %s, state %s, orientation %s: %s" % [tier_name_lc, state_str, orientation_str, tier_animations])

      animation_name = tier_animations[0]
      break

  if animation_name == "": # if no animation has been found that can be used, give a warning
    if Engine.is_editor_hint(): # if we are in the editor, then it is development error and still has attention 
      push_warning("No animation at or below current tier, check the animations")
    else: # else, it is a runtime error, so it is not going to be touched anytime soon, so raise attention: push_error
      push_error("No animation at or below current tier, how did the building get on the map?")
    animation_name = self.sprite_frames.get_animation_names()[0] # use first animation as fallback
  animated_sprite.play(animation_name)

func set_can_build_shader(can_build: bool) -> void:
  if self.has_node("AnimatedSprite2D"):
    var shader: ShaderMaterial = self.cannot_build_material if not can_build else null
    self.get_node("AnimatedSprite2D").material = shader
