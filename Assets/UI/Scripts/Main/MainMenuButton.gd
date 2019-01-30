extends TextureButton

export var allignement = "left"
export var text = ""
export var texture = preload("res://Assets/UI/Icons/MainMenu/help_bw.png")

var allignements = {
	left = Vector2(-200, 30),
	right = Vector2(100, 30),
	top = Vector2(-50, -35),
	bottom = Vector2(-50, 100)
}

func _ready():
	$Panel.rect_position = allignements[allignement]
	$Icon.texture = texture
	$Panel/Label.text = text
