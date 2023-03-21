@tool
extends TextureRect
class_name ResourceItem

#const Global = preload("res://Assets/World/Global.gd") TODO: Remove if possible

@export var resource_type: Global.ResourceType : set = set_resource_type

func set_resource_type(new_resource_type: int) -> void:
	resource_type = wrapi(new_resource_type, 0, Global.RESOURCE_TYPES.size())

	texture = Global.RESOURCE_TYPES[resource_type]

	notify_property_list_changed()
