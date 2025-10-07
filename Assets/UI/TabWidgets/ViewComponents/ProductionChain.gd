@tool
extends Control
## If visible, will show the production chain and progress info.

class_name ProductionChain

@export var number_inputs: int = 1 : set = set_number_inputs

# can be commented out below
@export var input_one_type: StringName : set = set_input_one_type
@export var input_two_type: StringName : set = set_input_two_type
@export var input_three_type: StringName : set = set_input_three_type
@export var output_type: StringName : set = set_output_type

@export var input_one_value: int : set = set_input_one_value
@export var input_two_value: int : set = set_input_two_value
@export var input_three_value: int : set = set_input_three_value
@export var output_value: int : set = set_output_value

@export var input_one_storage_limit: int = 10 : set = set_input_one_storage_limit
@export var input_two_storage_limit: int = 10 : set = set_input_two_storage_limit
@export var input_three_storage_limit: int = 10 : set = set_input_three_storage_limit
@export var output_storage_limit: int = 10 : set = set_output_storage_limit
# can be commented out above

@onready var vbox_container := find_child("VBoxContainer")
@onready var top_section := find_child("TopSection")
@onready var middle_section := find_child("MiddleSection")
@onready var arrow_start := find_child("ArrowStart")
@onready var bottom_section := find_child("BottomSection")

@onready var input_one := find_child("InputOne") as InventorySlot
@onready var input_two := find_child("InputTwo") as InventorySlot
@onready var input_three := find_child("InputThree") as InventorySlot
@onready var output := find_child("Output") as InventorySlot

@onready var progress_bar: ColorRect = self.get_node("MarginContainer/VBoxContainer/MiddleSection/Control/ProgressBar/ProgressBar/ProgressBar")
@onready var progress_bar_spacer: Control = self.get_node("MarginContainer/VBoxContainer/MiddleSection/Control/ProgressBar/ProgressBar/Spacer")

var slot_storage: SlotStorageComponent = null
var production_line: ProductionLineComponent = null

func _ready():
  if Engine.is_editor_hint():
    self.set_process(false)
  else:
    self.set_process(true)

func _process(_delta):
  if self.is_visible_in_tree():
    update_progress_bar()
    update_resource_amount()

func update_resource_amount():
  if self.slot_storage == null:
    return  

  # get the amount of the input resources
  self.input_one.resource_amount = self.slot_storage.storage.get(self.input_one.resource_type, 0)
  self.input_two.resource_amount = self.slot_storage.storage.get(self.input_two.resource_type, 0)
  self.input_three.resource_amount = self.slot_storage.storage.get(self.input_three.resource_type, 0)
  # set the input limits 
  self.input_one.limit = self.slot_storage.max_capacity.get(self.input_one.resource_type, 1)
  self.input_two.limit = self.slot_storage.max_capacity.get(self.input_two.resource_type, 1)
  self.input_three.limit = self.slot_storage.max_capacity.get(self.input_three.resource_type, 1)
  # set the output value and limit
  self.output.resource_amount = self.slot_storage.storage.get(self.output.resource_type, 0)
  self.output.limit = self.slot_storage.max_capacity.get(self.output.resource_type, 1)

func update_progress_bar():
  var progress: float = 0
  if self.production_line:
    progress = 1 - (self.production_line.production_time_end - Time.get_unix_time_from_system()) / self.production_line.production_time
    if progress > 1 or progress < 0:
      progress = 0
  self.progress_bar.size_flags_stretch_ratio = progress
  self.progress_bar_spacer.size_flags_stretch_ratio = 1 - progress

## Updates the production chain inputs and outputs
func set_production_line(production_line: ProductionLineComponent, slot_storage: SlotStorageComponent):
  self.slot_storage = slot_storage
  self.production_line = production_line
  if production_line == null or slot_storage == null:
    return
  # update the inputs
  self.input_one.resource_type = ResourceConfig.Resources.NONE
  self.input_two.resource_type = ResourceConfig.Resources.NONE
  self.input_three.resource_type = ResourceConfig.Resources.NONE
  var consume_keys: Array[StringName] = production_line.consumes.keys()
  consume_keys.sort_custom(func(a, b): return production_line.consumes[a] < production_line.consumes[b])
  self.set_number_inputs(len(consume_keys))

  match len(consume_keys):
    1:
      self.input_two.resource_type = consume_keys[0]
      self.input_two.resource_amount = slot_storage.storage.get(consume_keys[0], 0)
    2:
      self.input_one.resource_type = consume_keys[0]
      self.input_one.resource_amount = slot_storage.storage.get(consume_keys[0], 0)
      self.input_three.resource_type = consume_keys[1]
      self.input_three.resource_amount = slot_storage.storage.get(consume_keys[1], 0)
    3:
      self.input_one.resource_type = consume_keys[0]
      self.input_one.resource_amount = slot_storage.storage.get(consume_keys[0], 0)
      self.input_two.resource_type = consume_keys[1]
      self.input_two.resource_amount = slot_storage.storage.get(consume_keys[1], 0)
      self.input_three.resource_type = consume_keys[2]
      self.input_three.resource_amount = slot_storage.storage.get(consume_keys[2], 0)

  # update the output
  var produces_keys: Array[StringName] = production_line.produces.keys()
  produces_keys.sort_custom(func(a, b): return production_line.produces[a] < production_line.produces[b])

  self.output.resource_type = produces_keys[0]
  self.output.resource_amount = production_line.produces[produces_keys[0]]
  update_progress_bar()
  update_resource_amount()

func set_number_inputs(new_number_inputs: int) -> void:
  if not is_inside_tree():
    await self.ready

  number_inputs = clamp(new_number_inputs, 0, 3) as int

  match number_inputs:
    0: _set_inputs(false, false, false)
    1: _set_inputs(false, true, false)
    2: _set_inputs(true, false, true)
    3: _set_inputs(true, true, true)

# can be commented out below
func set_input_one_type(new_input_one_type: StringName) -> void:
  input_one_type = new_input_one_type
  if not is_inside_tree():
    await self.ready

  input_one.resource_type = input_one_type

func set_input_two_type(new_input_two_type: StringName) -> void:
  input_two_type = new_input_two_type
  if not is_inside_tree():
    await self.ready

  input_two.resource_type = input_two_type


func set_input_three_type(new_input_three_type: StringName) -> void:
  input_three_type = new_input_three_type
  if not is_inside_tree():
    await self.ready

  input_three.resource_type = input_three_type

func set_output_type(new_output_type: StringName) -> void:
  output_type = new_output_type
  if not is_inside_tree():
    await self.ready

  output.resource_type = output_type

func set_input_one_value(new_input_one_value: int) -> void:
  input_one_value = new_input_one_value
  if not is_inside_tree():
    await self.ready

  input_one.resource_amount = input_one_value
  notify_property_list_changed()

func set_input_two_value(new_input_two_value: int) -> void:
  input_two_value = new_input_two_value
  if not is_inside_tree():
    await self.ready

  input_two.resource_amount = input_two_value
  notify_property_list_changed()

func set_input_three_value(new_input_three_value: int) -> void:
  input_three_value = new_input_three_value
  if not is_inside_tree():
    await self.ready

  input_three.resource_amount = input_three_value
  notify_property_list_changed()

func set_output_value(new_output_value: int) -> void:
  if not is_inside_tree():
    await self.ready

  output.resource_amount = new_output_value
  output_value = output.resource_amount

  notify_property_list_changed()

func set_input_one_storage_limit(new_input_one_storage_limit: int) -> void:
  input_one_storage_limit = new_input_one_storage_limit
  if not is_inside_tree():
    await self.ready

  input_one.limit = input_one_storage_limit

func set_input_two_storage_limit(new_input_two_storage_limit: int) -> void:
  input_two_storage_limit = new_input_two_storage_limit
  if not is_inside_tree():
    await self.ready

  input_two.limit = input_two_storage_limit

func set_input_three_storage_limit(new_input_three_storage_limit: int) -> void:
  input_three_storage_limit = new_input_three_storage_limit
  if not is_inside_tree():
    await self.ready

  input_three.limit = input_three_storage_limit

func set_output_storage_limit(new_output_storage_limit: int) -> void:
  output_storage_limit = new_output_storage_limit
  if not is_inside_tree():
    await self.ready

  output.limit = output_storage_limit
# can be commented out above

func _set_input_one(enabled: bool) -> void:
  top_section.visible = enabled

func _set_input_two(enabled: bool) -> void:
  input_two.modulate.a = 1 if enabled else 0
  arrow_start.visible = enabled

func _set_input_three(enabled: bool) -> void:
  bottom_section.visible = enabled

func _set_inputs(input_one: bool, input_two: bool, input_three: bool) -> void:
  _set_input_one(input_one)
  _set_input_two(input_two)
  _set_input_three(input_three)

  queue_redraw()

func _notification(what: int) -> void:
  match what:
    NOTIFICATION_DRAW:
      if not is_inside_tree():
        await self.ready

      # Reset to minimum size first.
      custom_minimum_size = middle_section.size
      vbox_container.size = custom_minimum_size

      # Then expand to necessary size.
      custom_minimum_size = vbox_container.size

      # Control node cannot expand automatically to min size, so force it.
      size = custom_minimum_size

      notify_property_list_changed()
