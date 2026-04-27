class_name Notice230ConfirmModal
extends RefCounted

## Matches po/uh/unknown-horizons.pot (horizons/gui/gui.py quit flow).
const QUIT_CONFIRM_TITLE: String = "Quit Game"
const QUIT_CONFIRM_MESSAGE: String = "Are you sure you want to quit Unknown Horizons?"

const _MODAL_LAYER_DEFAULT: int = 80
const _DIM_COLOR_DEFAULT: Color = Color(0, 0, 0, 0.55)
const _NOTICE_BG: String = "res://Assets/UI/Images/Background/notice230.png"
const _NOTICE_SIZE: Vector2 = Vector2(374, 230)
const _FONT_TITLE: Font = preload("res://External/Fonts/LinLibertineB.ttf")
const _FONT_BODY: Font = preload("res://External/Fonts/LinLibertineI.ttf")
const _TEXT_COLOR: Color = Color(0.258824, 0.188235, 0.0509804, 1)
const _OK_BUTTON: PackedScene = preload(
	"res://Assets/UI/BasicControls/RoundButtons/OKButton.tscn"
)
const _CANCEL_BUTTON: PackedScene = preload(
	"res://Assets/UI/BasicControls/RoundButtons/CancelButton.tscn"
)

static func present(
	tree: SceneTree,
	title: String,
	message: String,
	on_confirmed: Callable,
	layer: int = _MODAL_LAYER_DEFAULT,
	dim_color: Color = _DIM_COLOR_DEFAULT,
) -> void:
	if tree == null or tree.root == null:
		return

	var modal_layer := CanvasLayer.new()
	modal_layer.layer = layer

	var dimmer := ColorRect.new()
	dimmer.set_anchors_preset(Control.PRESET_FULL_RECT)
	dimmer.offset_left = 0.0
	dimmer.offset_top = 0.0
	dimmer.offset_right = 0.0
	dimmer.offset_bottom = 0.0
	dimmer.color = dim_color
	dimmer.mouse_filter = Control.MOUSE_FILTER_STOP
	modal_layer.add_child(dimmer)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	modal_layer.add_child(center)

	var notice: Control = _build_panel(modal_layer, title, message, on_confirmed)
	var ui_theme: Theme = ThemeDB.get_project_theme()
	if ui_theme != null:
		notice.theme = ui_theme
	center.add_child(notice)

	tree.root.add_child(modal_layer)
	var ok_focus_target: Control = notice.get_node("Content/VBox/ButtonRow/OKButton") as Control
	if ok_focus_target != null:
		ok_focus_target.call_deferred(&"grab_focus")


static func _build_panel(
	modal_layer: CanvasLayer,
	title: String,
	message: String,
	on_confirmed: Callable,
) -> Control:
	var panel := PanelContainer.new()
	panel.name = "Notice230Confirm"
	panel.custom_minimum_size = _NOTICE_SIZE
	var panel_bg := StyleBoxTexture.new()
	var note_tex: Texture2D = load(_NOTICE_BG) as Texture2D
	panel_bg.texture = note_tex
	panel.add_theme_stylebox_override(&"panel", panel_bg)

	# Margins roughly match content/gui/xml/mainmenu/templates/popup_230.xml (notice230 art).
	var margin := MarginContainer.new()
	margin.name = "Content"
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.name = "VBox"
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)

	var title_lbl := Label.new()
	# Fife headline is drawn all-caps in the parchment popup art.
	title_lbl.text = title.to_upper()
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title_lbl.add_theme_font_override(&"font", _FONT_TITLE)
	title_lbl.add_theme_font_size_override(&"font_size", 18)
	title_lbl.add_theme_color_override(&"font_color", _TEXT_COLOR)
	vbox.add_child(title_lbl)

	var sep := HSeparator.new()
	sep.theme_type_variation = &"HSeparatorBrownThin"
	vbox.add_child(sep)

	# Body sits in the band between the rule and buttons, vertically centered like popup_230.
	var body_slot := CenterContainer.new()
	body_slot.name = "BodySlot"
	body_slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body_slot.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(body_slot)

	var body_lbl := Label.new()
	body_lbl.text = message
	body_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	body_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	body_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body_lbl.custom_minimum_size = Vector2(304, 0)
	body_lbl.add_theme_font_override(&"font", _FONT_BODY)
	body_lbl.add_theme_font_size_override(&"font_size", 16)
	body_lbl.add_theme_color_override(&"font_color", _TEXT_COLOR)
	body_slot.add_child(body_lbl)

	var btn_row := HBoxContainer.new()
	btn_row.name = "ButtonRow"
	btn_row.size_flags_vertical = Control.SIZE_SHRINK_END
	btn_row.add_theme_constant_override("separation", 0)
	btn_row.alignment = BoxContainer.ALIGNMENT_BEGIN
	vbox.add_child(btn_row)

	var cancel_btn: TextureButton = _CANCEL_BUTTON.instantiate() as TextureButton
	cancel_btn.name = "CancelButton"
	cancel_btn.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	var esc_shortcut := Shortcut.new()
	var esc_ev := InputEventKey.new()
	esc_ev.keycode = KEY_ESCAPE
	esc_shortcut.events.append(esc_ev)
	cancel_btn.shortcut = esc_shortcut
	cancel_btn.shortcut_in_tooltip = false
	cancel_btn.pressed.connect(
		func () -> void:
			if is_instance_valid(modal_layer) and not modal_layer.is_queued_for_deletion():
				modal_layer.queue_free()
	)
	btn_row.add_child(cancel_btn)

	var btn_spacer := Control.new()
	btn_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn_row.add_child(btn_spacer)

	var ok_btn: TextureButton = _OK_BUTTON.instantiate() as TextureButton
	ok_btn.name = "OKButton"
	ok_btn.size_flags_horizontal = Control.SIZE_SHRINK_END
	var ok_shortcut := Shortcut.new()
	for keycode: Key in [KEY_ENTER, KEY_KP_ENTER]:
		var ok_ev := InputEventKey.new()
		ok_ev.keycode = keycode
		ok_shortcut.events.append(ok_ev)
	ok_btn.shortcut = ok_shortcut
	ok_btn.shortcut_in_tooltip = false
	ok_btn.pressed.connect(
		func () -> void:
			if is_instance_valid(modal_layer) and not modal_layer.is_queued_for_deletion():
				modal_layer.queue_free()
			on_confirmed.call()
	)
	btn_row.add_child(ok_btn)

	return panel
