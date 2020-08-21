extends OptionButton

func _on_OptionButton_item_selected(_index: int) -> void:
	Audio.play_snd_click()

func _add_hover() -> void:
	# Restore color override hack when previously unhovered
	#add_color_override("font_color_hover", null) # Why does not null work? How to clear properly?
	set("custom_colors/font_color_hover", null) # use this then

	if has_icon("arrow_hover", "OptionButton") and not has_icon_override("arrow"):
		add_icon_override("arrow", theme.get_icon("arrow_hover", "OptionButton"))

func _remove_hover() -> void:
	# Assign normal color style reliably
	add_color_override("font_color_hover", theme.get_color("font_color", "OptionButton"))

	if has_icon_override("arrow"):
		add_icon_override("arrow", null)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAW:
			if not disabled and modulate != Color.white:
				modulate = Color.white
			elif disabled and modulate != Color.darkgray:
				modulate = Color.darkgray
		NOTIFICATION_MOUSE_ENTER:
			if not disabled:
				_add_hover()
		NOTIFICATION_MOUSE_EXIT:
			if not get_popup().visible:
				_remove_hover()
		NOTIFICATION_FOCUS_ENTER: # occurs when PopupMenu closes
			var mouse_is_inside = get_global_rect().has_point(get_global_mouse_position())

			# Remove hover when PopupMenu closes and focus returns back to
			# OptionButton but the mouse has been moved away in the meantime
			if not mouse_is_inside:
				_remove_hover()
