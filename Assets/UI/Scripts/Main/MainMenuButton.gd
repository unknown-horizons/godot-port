tool
extends TextureButton

export var allignement := "left"
export var text := ""
export var texture: Texture =\
		preload("res://Assets/UI/Icons/MainMenu/help_bw.png") # Fallback.

var allignements = {
	left = Vector2(-200, 30),
	right = Vector2(100, 30),
	top = Vector2(-50, -35),
	bottom = Vector2(-50, 100)
}

func _ready() -> void:
	$Panel.rect_position = allignements[allignement]
	$Panel/Label.text = text
	$Icon.texture = texture
