extends Spatial
class_name PlayerStart

onready var ships := $Ships.get_children()

func _ready() -> void:
	Global.PlayerStart = self

	get_node("VisualMarker").get("material/0").set("albedo_color", Color(1, 1, 1, 0))

	for ship in ships:
		ship.direction = randi() % Ship.RotationDegree.size()
