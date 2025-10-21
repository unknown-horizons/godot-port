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
    if self.animated_sprite == null:
      return
    self.animated_sprite.sprite_frames = sprite_frames
    if sprite_frames == null:
      push_warning("No sprite frames assigned")
    update_animation()

@export var action_state: ActionStates = ActionStates.IDLE:
  set(value): 
    action_state = value
    update_animation()

@export var storage_state: StorageStates = StorageStates.EMPTY:
  set(value):
    storage_state = value
    update_animation()

## The rotation of the building, used to determine the animation
@export var orientation: Orientations = Orientations._045:
  set(value):
    orientation = value
    update_animation()

## The current world's tier
@export var current_tier: WorldTiers.TierEnum = WorldTiers.TierEnum.MAX:
  set(value):
    current_tier = value
    if self.per_tier_animation_names.size() > 0 and self.per_tier_animation_names[current_tier].size() > 0:
      self.current_as_name = self.per_tier_animation_names[current_tier][0].split(".")[0] # TODO: pick random as_name
    self.update_animation()

# @export # no need to export - there is a custom one @ _get_property_list
var current_as_name: String = "":
  set(value):
    current_as_name = value
    self.update_animation()

@onready var animated_sprite: AnimatedSprite2D = self.get_node("AnimatedSprite2D")

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
  per_tier_animation_names.resize(WorldTiers.TierEnum.MAX + 1)

  for animation_name in self.sprite_frames.get_animation_names():
    var parts = animation_name.split(".")
    if parts.size() < 2:
      push_error("Unknown animation_name: %s" % animation_name)
      continue  # skip malformed
    var animation_tier_name = parts[1].to_upper()  # e.g. "MERCHANTS"
    if WorldTiers.TierEnum.has(animation_tier_name):
      var tier_enum: WorldTiers.TierEnum = WorldTiers.TierEnum[animation_tier_name]
      per_tier_animation_names[tier_enum].push_back(animation_name)
    else:
      push_error("Unknown tier: %s" % animation_tier_name)

    if self.per_tier_animation_names.size() > 0 and self.per_tier_animation_names[current_tier].size() > 0:
      self.current_as_name = self.per_tier_animation_names[current_tier][0].split(".")[0] # TODO: pick random as_name

  update_animation()

func set_components(new_components: Array[BaseComponent]) -> void:
  for component in new_components:
    var storage_component = component as StorageComponent
    var production_line_component = component as ProductionLineComponent
    var move_by_cell_component = component as MoveByCellComponent
    if storage_component != null:
      storage_component.storage_changed.connect(set_storage_state)
    if production_line_component != null:
      production_line_component.action_state_changed.connect(func(action_state): self.action_state = action_state)
    if move_by_cell_component != null:
      move_by_cell_component.action_state_changed.connect(func(action_state): self.action_state = action_state)
      move_by_cell_component.orientation_changed.connect(func(orientation): self.orientation = orientation)

func set_storage_state(new_storage_state: StorageComponent.StorageComponentStates) -> void:
  match new_storage_state:
    StorageComponent.StorageComponentStates.EMPTY:
      self.storage_state = StorageStates.EMPTY
    StorageComponent.StorageComponentStates.PARTIALLY_FULL:
      if self.has_node(".."):
        var parent := self.get_parent()
        if parent is Building2D:
          self.storage_state = StorageStates.EMPTY
        elif parent is Collector:
          self.storage_state = StorageStates.FULL
    StorageComponent.StorageComponentStates.FULL:
      self.storage_state = StorageStates.FULL

func update_animation() -> void:
  # if the sprite frames or the animated sprite is null then return because there is nothing to update
  if animated_sprite == null or sprite_frames == null:
    return
  
  var orientation_str := str(snappedi(self.orientation, 45)).pad_zeros(3) # get the rotation as string
  # get the state as string
  var storage_state_str := str(StorageStates.find_key(self.storage_state)).to_lower()
  var action_state_str := str(ActionStates.find_key(self.action_state)).to_lower()
  if self.action_state == ActionStates.WORK:
    storage_state_str = "empty"
  var state_str = action_state_str
  if storage_state_str != "empty":
    state_str += "_" + storage_state_str

  # get the last tier before the current at which we have an animation, as string
  var animation_name: String = ""

  for tier in range(self.current_tier, WorldTiers.TierEnum.MIN+1-1, -1): # start with tier and go backwards
    var tier_name_lc: String = WorldTiers.TierEnum.keys()[tier].to_lower() # the tier as a lowercase string
    var tier_animations = self.per_tier_animation_names[tier]
    if tier_animations.size() > 0: # if the tier contains any animations - we choose one from them
      var as_animations = tier_animations.filter(func(k: String): return k.begins_with(self.current_as_name+"."))
      if as_animations.size() > 0: # if actionset_name animation present - choose only from animations corresponding to the actionset_name
        tier_animations = as_animations
      var orientation_animations = tier_animations.filter(func(k): return k.contains(orientation_str))
      if orientation_animations.size() > 0: # if orientation animation present - choose only from the animations corresponding to the orientation
        tier_animations = orientation_animations

      var working_state_animations = tier_animations.filter(func(k): return k.contains("."+state_str+".")) # lease priority for filtering
      if working_state_animations.size() > 0: # if working state animation present - choose only from the animations corresponding to the working state
        tier_animations = working_state_animations
      
      if tier_animations.size() > 1:
        # TODO: we filter logs and planks for now. Those need to be an overlay layer on top of the lumberjack (hut) animation
        tier_animations = tier_animations.filter(func(k): return not k.contains(".logs_") and not k.contains(".planks_"))

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
  
  var building_instance := self.get_parent() as Building2D

  if building_instance != null: # use building_instance.size to determine the multicell sprite offset 
    var texture = self.animated_sprite.sprite_frames.get_frame_texture(animation_name, 0)
    var w = texture.get_width()
    var h = texture.get_height()
    self.animated_sprite.centered = false
    # the multicell sprites are aligned at the center of bottom.
    # Cell size is 64x32. The midpoint of bottom cell is (h-32/2). The horizontal offset depends if the sprite is square (2x2, 3x3, etc) or rectangular (3x2, etc). 
    if building_instance.size.x == building_instance.size.y: # a square footprint for the building
      self.animated_sprite.offset = Vector2(-w/2, -(h-32/2)) # where 32 - is cell height.
    else: # non square footprint sprite (2x3, 3x4 etc)
      if self.orientation == 135 or self.orientation == 315: # 2x3 isometric (goes up right "/") => the bottom cell is shifted left comparing to the center of the image
        self.animated_sprite.offset = Vector2(-building_instance.size.x*64/2, -(h-32/2))
        pass
      elif self.orientation == 45 or self.orientation == 225: # 2x3 isometric (goes up left "\") => the bottom cell is shifted right comparing to the center of the image
        self.animated_sprite.offset = Vector2(-building_instance.size.y*64/2, -(h-32/2))
      else:
        self.animated_sprite.offset = Vector2(-w/2, -(h-32/2))
        push_error("Unexpected orientation: %s" % self.orientation)
  self.animated_sprite.play(animation_name)

func set_can_build_shader(can_build: bool) -> void:
  if self.has_node("AnimatedSprite2D"):
    var shader: ShaderMaterial = self.cannot_build_material if not can_build else null
    self.get_node("AnimatedSprite2D").material = shader
