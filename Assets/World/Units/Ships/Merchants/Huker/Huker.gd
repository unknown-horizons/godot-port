tool
extends Ship
class_name Huker

onready var faction_color: Sprite3D = $FactionColor as Sprite3D

func update_faction_color() -> void:
	if faction_color != null:

		# Use a preconfigured material as a base
		var material = Global.COLOR_MATERIAL[faction] as ShaderMaterial
		material = material.duplicate()

		# Apply specific parameters to this instance
		material.set_shader_param("texture_albedo", texture)

		faction_color.set_material_override(material)

		# Match rotation of the ship's color outline with the main texture rotation
		faction_color.frame = _billboard.frame
