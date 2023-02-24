tool
extends TextureRect
class_name ResourceItem

const Global = preload("res://Assets/World/Global.gd")

export(Global.ResourceType) var resource_type setget set_resource_type

func set_resource_type(new_resource_type: int) -> void:
	resource_type = wrapi(new_resource_type, 0, Global.RESOURCE_TYPES.size())

	texture = Global.RESOURCE_TYPES[resource_type]

	property_list_changed_notify()
