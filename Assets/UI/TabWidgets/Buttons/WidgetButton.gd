@tool
extends TextureButton
class_name WidgetButton

## Base class for all widget buttons.
##
## All input events are catched by the (larger) child node (background)
## and passed only when the cursor lies in a valid / triggerable location
## (i.e. inside the sprite's opaque region).[br][br]
##
## Since there is currently no proper way to trigger the button to leave
## the hovered state once the mouse left again, we force-disable it by
## clearing the texture_hover value, caching it inside the class and then
## swap it back and forth into the texture slot whenever actually needed.

## ❗TODO: Investigate what's needed in total and
##		create several styles for various purposes.
##		Unused for now, maybe not this much of variation needed after all?
enum Style {
	NONE,
	ROUNDED,
	SQUARED_SMALL,
	SQUARED_MEDIUM,
	SQUARED_LARGE,
}

const STYLES = [
	preload("res://Assets/UI/Images/Buttons/msg_button.png"),
	preload("res://Assets/UI/Images/Background/sq.png"),
	preload("res://Assets/UI/Images/Background/square_80.png"),
	preload("res://Assets/UI/Images/Background/square_120.png"),
]

const TEXTURE_CLICK_MASK_ROUNDED = preload("res://Assets/UI/Images/Buttons/msg_button_mask.png")

#export var styles_view_only := STYLES # (Array, Texture2D)
#export var style: Style := Style.ROUNDED #: set = set_style

@onready var texture_rect := $TextureRect as TextureRect
@onready var _texture_hover := texture_hover

func _ready() -> void:
#	prints("texture_normal.get_size()", texture_normal.get_size())
#	prints("size", size)
	if texture_normal:
		if texture_click_mask:
			if Vector2i(texture_normal.get_size()) != texture_click_mask.get_size():
				texture_rect.mouse_filter = Control.MOUSE_FILTER_PASS

func _draw() -> void:
	if texture_normal:
		if size > texture_normal.get_size():
			size = texture_normal.get_size()

			notify_property_list_changed()

func _pressed() -> void:
	Audio.play_snd_click()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_RESIZED:
			pivot_offset = size / 2 # always keep the pivot centered
			#texture_rect.pivot_offset = texture_rect.size / 2

#func set_style(new_style: int) -> void:
#	if not is_inside_tree(): await self.ready; _on_ready()
#
#	var configuration := {
#		Style.NONE:           [false, null, null],
#		Style.ROUNDED:        [true, STYLES[Style.ROUNDED - 1], TEXTURE_CLICK_MASK_ROUNDED],
#		Style.SQUARED_SMALL:  [true, STYLES[Style.SQUARED_SMALL - 1], null],
#		Style.SQUARED_MEDIUM: [true, STYLES[Style.SQUARED_MEDIUM - 1], null],
#		Style.SQUARED_LARGE:  [true, STYLES[Style.SQUARED_LARGE - 1], null],
#	}.get(new_style) as Array
#
#	texture_rect.visible = configuration[0]
#	texture_rect.texture = configuration[1]
#	texture_click_mask = configuration[2]
#
##	match new_style:
##		Style.NONE:
##			texture_rect.hide()
##			texture_rect.texture = null
##			texture_click_mask = null
##		Style.ROUNDED:
##			texture_rect.show()
##			texture_rect.texture = STYLES[Style.ROUNDED]
##			texture_click_mask = TEXTURE_CLICK_MASK_ROUNDED
##		Style.SQUARED_SMALL:
##			texture_rect.show()
##			texture_rect.texture = STYLES[Style.SQUARED_SMALL]
##			texture_click_mask = null
##		Style.SQUARED_MEDIUM:
##			texture_rect.show()
##			texture_rect.texture = STYLES[Style.SQUARED_MEDIUM]
##			texture_click_mask = null
##		Style.SQUARED_LARGE:
##			texture_rect.show()
##			texture_rect.texture = STYLES[Style.SQUARED_LARGE]
##			texture_click_mask = null
#
#	style = new_style

func _is_pixel_opaque(tolerance: int = 145) -> bool:
	var image := texture_rect.texture.get_data() as Image

	var pos_relative_to_rect :=\
			get_local_mouse_position() - texture_rect.position as Vector2

	var color := image.get_pixelv(pos_relative_to_rect) as Color
	if color.a8 > tolerance:
		#prints(pos_relative_to_rect, color.a8)
		return true
	else:
		return false

func _on_ActionButton_gui_input(_event: InputEvent) -> void:
	pass # Override in sub-class for specific behavior

func _on_ActionButton_mouse_entered() -> void:
	pass # Override in sub-class for specific behavior
	prints("entered")

func _on_ActionButton_mouse_exited() -> void:
	pass # Override in sub-class for specific behavior
	prints("exited")

func _on_TextureRect_gui_input(_event: InputEvent) -> void:
	return # TODO: Revise function for Godot 4

	if not texture_rect.visible:
		return

	if size <= texture_rect.size:
		if _is_pixel_opaque():
			#mouse_filter = Control.MOUSE_FILTER_STOP
			texture_rect.mouse_filter = Control.MOUSE_FILTER_PASS
			texture_hover = _texture_hover
			return

		#mouse_filter = Control.MOUSE_FILTER_IGNORE
		texture_hover = null
		texture_rect.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_ready() -> void:
	if texture_rect == null: texture_rect = $TextureRect as TextureRect
