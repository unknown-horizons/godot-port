tool
extends Ship
class_name Huker

onready var faction_color: Sprite3D = $FactionColor as Sprite3D

func update_faction_color() -> void:
	if faction_color != null:
		var mat = Global.COLOR_MATERIAL[faction] as ShaderMaterial
		faction_color.set_material_override(mat)

		faction_color.frame = _billboard.frame
