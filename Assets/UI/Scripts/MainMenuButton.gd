tool
extends TextureButton

export(String, "left", "right", "top", "bottom") var alignment := "left" setget set_alignment
export var text := "" setget set_text
export var texture: Texture = preload("res://Assets/UI/Icons/MainMenu/help_bw.png") setget set_texture # Fallback

var alignments = {
	left = Vector2(-200, 30),
	right = Vector2(100, 30),
	top = Vector2(-50, -35),
	bottom = Vector2(-50, 100)
}

func _ready() -> void:
	$Panel.rect_position = alignments[alignment]
	$Panel/Label.text = text
	$Icon.texture = texture

func set_alignment(new_alignment: String) -> void:
	alignment = new_alignment
	$Panel.rect_position = alignments[alignment]

func set_text(new_text: String) -> void:
	text = new_text
	$Panel/Label.text = text

func set_texture(new_texture: Texture) -> void:
	texture = new_texture
	$Icon.texture = texture
