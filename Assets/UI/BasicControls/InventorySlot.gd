@tool
extends TextureButton
class_name InventorySlot

@export var show_if_empty: bool = false : set = set_show_if_empty
@export var resource_type: Global.ResourceType : set = set_resource_type
@export var resource_value: int : set = set_resource_value

## [b]❗TODO: Make dependent from currently selected ship.[/b]
@export var storage_limit: int = 30 : set = set_storage_limit

@onready var resource_item = $ResourceItem
@onready var label = $LabelEx
@onready var texture_rect = $TextureRect

func _ready() -> void:
	texture_rect.pivot_offset = texture_rect.size

func _draw() -> void:
	if not is_inside_tree():
		await self.ready

	update_display()

func update_display() -> void:
	if resource_type != Global.ResourceType.NONE and show_if_empty or \
		resource_type != Global.ResourceType.NONE and resource_value > 0:
		set_slot_status(true)
	else:
		set_slot_status(false)

func set_slot_status(active: bool) -> void:
	var status = {
		true: "show",
		false: "hide"
	}.get(active)

	resource_item.call(status)
	label.call(status)
	texture_rect.call(status)

func set_show_if_empty(new_show_if_empty: bool) -> void:
	show_if_empty = new_show_if_empty

	_draw()

func set_resource_type(new_resource_type: int) -> void:
	if not is_inside_tree():
		await self.ready

	#prints(self.name, "resource_type", resource_type, "=>", new_resource_type)

	resource_type = wrapi(new_resource_type, 0, Global.RESOURCE_TYPES.size())

	resource_item.resource_type = resource_type

	_draw()

func set_resource_value(new_resource_value: int) -> void:
	if not is_inside_tree():
		await self.ready

	#prints(self.name, "resource_value", resource_value, "=>", new_resource_value)

	resource_value = clamp(new_resource_value, 0, storage_limit) as int

	label.text = str(resource_value)
	update_amount_bar()

	_draw()

func set_storage_limit(new_storage_limit: int) -> void:
	if not is_inside_tree():
		await self.ready

	#prints(self.name, "storage_limit", storage_limit, "=>", new_storage_limit)

	storage_limit = clamp(new_storage_limit, 0, new_storage_limit) as int

	# Always keep resource_value within the storage_limit
	self.resource_value = clamp(resource_value, 0, storage_limit) as int
	notify_property_list_changed()

	update_amount_bar()

func update_amount_bar() -> void:
	if not is_inside_tree():
		await self.ready

	var scale_factor: float
	if storage_limit > 0:
		scale_factor = snapped(1.0 / storage_limit * resource_value, 0.01) as float
	else:
		scale_factor = 0
	texture_rect.scale.y = scale_factor
