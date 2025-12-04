@tool
extends TextureRect

@export var resource_type: Global.ResourceType : set = set_resource_type
@export var resource_value: int : set = set_resource_value

@onready var texture_rect := $VBoxContainer/TextureRect
@onready var label := $VBoxContainer/LabelEx as Label

func set_resource_type(new_resource_type: int) -> void:
	if not is_inside_tree():
		await self.ready

	resource_type = wrapi(new_resource_type, 0, Global.RESOURCE_TYPES.size())
	texture_rect.texture = Global.RESOURCE_TYPES[resource_type]

func set_resource_value(new_resource_value: int) -> void:
	if not is_inside_tree():
		await self.ready

	resource_value = new_resource_value
	label.text = str(resource_value)
