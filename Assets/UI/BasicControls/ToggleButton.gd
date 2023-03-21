@tool
extends WidgetButton
class_name ToggleButton

## Button that cycles between two states visually.
##
## ❗TODO: Clean up and possibly merge into base button class.

@export var texture_normal_initial: Texture2D : set = set_texture_normal_initial
@export var texture_pressed_initial: Texture2D : set = set_texture_pressed_initial
@export var texture_hover_initial: Texture2D : set = set_texture_hover_initial
@export var texture_normal_alternate: Texture2D
@export var texture_pressed_alternate: Texture2D
@export var texture_hover_alternate: Texture2D

@onready var animated_texture := get_node_or_null("AnimatedTexture")

func _ready() -> void:
	super()

	_set_animation()

func _pressed() -> void:
	Audio.play_snd_click()

func _toggled(button_pressed: bool) -> void:
	var texture_variant = {
		true: "alternate",
		false: "initial",
	}.get(button_pressed)

	for texture_type in ["normal", "pressed", "hover"]:
		#prints("Set", texture_type + "_" + texture_variant, "for", texture_type, "_texture")
		call("set_texture_{0}".format([texture_type]),
			get("texture_{0}_{1}".format([texture_type, texture_variant]))
		)

	_set_animation()

func set_texture_normal_initial(new_texture_normal_initial: Texture2D) -> void:
	texture_normal_initial = new_texture_normal_initial
	texture_normal = texture_normal_initial

	notify_property_list_changed()

func set_texture_pressed_initial(new_texture_pressed_initial: Texture2D) -> void:
	texture_pressed_initial = new_texture_pressed_initial
	texture_pressed = texture_pressed_initial

	notify_property_list_changed()

func set_texture_hover_initial(new_texture_hover_initial: Texture2D) -> void:
	texture_hover_initial = new_texture_hover_initial
	texture_hover = texture_hover_initial

	notify_property_list_changed()

func _set_animation() -> void:
	if animated_texture:
		if button_pressed:
			animated_texture.hide()
			texture_normal = texture_normal_initial if not button_pressed else texture_normal_alternate
		else:
			animated_texture.show()
			texture_normal = null
		#prints("animated_texture.visible:", animated_texture.visible)

func _on_ActionButton_gui_input(_event: InputEvent) -> void:
	if animated_texture:
		animated_texture.hide()

#func _on_ActionButton_mouse_entered() -> void:
#	animated_texture.hide()

func _on_ActionButton_mouse_exited() -> void:
	prints("exited")
	if animated_texture:
		if not button_pressed:
			animated_texture.show()
