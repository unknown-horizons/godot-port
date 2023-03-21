extends Node3D
class_name PlayerStart

@onready var ships := $Ships.get_children()

func _ready() -> void:
	Global.PlayerStart = self

	%VisualMarker.queue_free()

	for ship in ships:
		ship.direction = randi() % Ship.RotationDegree.size()
