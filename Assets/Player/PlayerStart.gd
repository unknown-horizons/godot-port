extends MeshInstance
class_name PlayerStart

func _ready() -> void:
	Global.PlayerStart = self

	get("material/0").set("albedo_color", Color(1, 1, 1, 0))

	var ships: Array = get_children()
	for ship in ships:
		ship.direction = randi() % Ship.RotationDegree.size()
