extends "res://Assets/World/component.gd"

var node
export(Vector2) var vector = Vector2()
export(float) var rotation = 0

func _get_serializable_fields():
    return ["vector", "rotation"]