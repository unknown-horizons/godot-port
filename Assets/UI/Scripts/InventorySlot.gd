tool
extends TextureRect

const Global = preload("res://Assets/World/Global.gd")

export(Global.ResourceType) var resource_type setget set_resource_type
export(int) var resource_value setget set_resource_value

# TODO: Make dependent from currently selected ship
export(int) var storage_limit := 30 setget set_storage_limit

onready var texture_rect = $TextureRect
onready var label = $Label
onready var texture_rect2 = $TextureRect2

func _ready() -> void:
	texture_rect2.rect_pivot_offset = texture_rect2.rect_size

func set_resource_type(new_resource_type: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	resource_type = wrapi(new_resource_type, 0, Global.RESOURCE_TYPES.size())

	texture_rect.texture = Global.RESOURCE_TYPES[resource_type]

func set_resource_value(new_resource_value: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	resource_value = clamp(new_resource_value, 0, storage_limit)

	label.text = str(resource_value)
	update_amount_bar()

func set_storage_limit(new_storage_limit: int) -> void:
	storage_limit = clamp(new_storage_limit, resource_value, new_storage_limit) as int
	update_amount_bar()

func update_amount_bar() -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	var scale_factor := stepify(1.0 / storage_limit * resource_value, 0.01) as float
	texture_rect2.rect_scale.y = scale_factor

func _on_ready() -> void:
	if not texture_rect: texture_rect = $TextureRect
	if not label: label = $Label
	if not texture_rect2: texture_rect2 = $TextureRect2
