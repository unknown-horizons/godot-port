@tool
extends TextureButton

@export_enum("left", "right", "top", "bottom") var alignment := "left" : set = set_alignment
@export var text := "" : set = set_text
@export var texture: Texture2D = preload("res://Assets/UI/Icons/MainMenu/help_bw.png") : set = set_texture

var alignments = {
	left = Vector2(-200, 30),
	right = Vector2(100, 30),
	top = Vector2(-50, -35),
	bottom = Vector2(-50, 100)
}

func _ready() -> void:
	$Panel.position = alignments[alignment]
	$Panel/Label.text = text
	$Icon.texture = texture

func set_alignment(new_alignment: String) -> void:
	alignment = new_alignment
	$Panel.position = alignments[alignment]

func set_text(new_text: String) -> void:
	text = new_text
	$Panel/Label.text = text

func set_texture(new_texture: Texture2D) -> void:
	texture = new_texture
	$Icon.texture = texture
