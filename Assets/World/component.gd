extends Node

export(bool) var modified = false

func _ready():
    pass

func get_serializable_fields():
    return _get_serializable_fields()

func _get_serializable_fields():
    pass
