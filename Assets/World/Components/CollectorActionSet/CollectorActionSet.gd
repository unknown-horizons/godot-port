@tool

extends BaseComponent
## The action set component is used in buildings to determine the image and more.
## Important: The animation will be determined by "{tier_prefix}{base_prefix}{Angle}", with the tier_prefix being a first letter capitalized tier name.

class_name CollectorActionSet

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

## The rotation of the building, used to determine the animation
@export var direction: int = 45:
  set(value):
    direction = value
    update_animation()

## The current tier
@export var tier: ActionSetEnum.Tiers = ActionSetEnum.Tiers.MAX:
  set(value):
    tier = value
    update_animation()

@onready var animated_sprite: AnimatedSprite2D = self.get_node("AnimatedSprite2D")

## The current collector state, used to determine the animation
var collector_action: CollectorActions = CollectorActions.IDLE:
  set(value):
    collector_action = value
    update_animation()

## Does the collector have any load
var has_load: bool = false:
  set(value):
    has_load = value
    update_animation()

## The possible states of the collector
enum CollectorActions{
  ## The collector is in its idle state
  IDLE,
  ## The collector is in its walking state
  MOVE,
}

const empty_animation: String = "Empty"

func _ready():
  if animated_sprite:
    animated_sprite.sprite_frames = sprite_frames
  update_animation()

func update_animation() -> void:
  # if the sprite frames or the animated sprite is null then return because there is nothing to update
  if animated_sprite == null or sprite_frames == null:
    return
  
  var rotation_str: String = str(snappedi(self.direction, 45)) # get the rotation as string
  # get the state as string
  var state_str: String = CollectorActions.find_key(collector_action).to_lower()
  if has_load: # if the collector has load add "_full" to fullfill the state
    state_str += "_full"
  
  # get the last tier before the current at which we have an animation, as string
  var animation_name: String = ""
  for cur_tier in ActionSetEnum.Tiers.keys(): # iterate over all the tiers
    var tier_with_lower: String = cur_tier.to_lower() # the tier as a lowercase string
    var animation_name_at_tier: String = tier_with_lower + "_" + state_str + "_" + rotation_str # the animation name that would be at the current tier
    if sprite_frames.has_animation(animation_name_at_tier): # if we have the animation, set it as a possible animation
      animation_name = animation_name_at_tier
    if ActionSetEnum.Tiers[cur_tier] == tier: # tier in loop is equal to the actual tier, then break because we have checked all the previous tiers
      break
  
  if animation_name == "": # if no animation has been found that can be used, give a warning
    if Engine.is_editor_hint(): # if we are in the editor, then it is development error and still has attention 
      push_warning("No animation at or below current tier, check the animations")
    else: # else, it is a runtime error, so it is not going to be touched anytime soon, so raise attention: push_error
      push_error("No animation at or below current tier, how did the collector get on the map?")
    animation_name = empty_animation
  animated_sprite.play(animation_name)
