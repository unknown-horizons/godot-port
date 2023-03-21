@tool
extends GridContainer

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			var theme := load(ProjectSettings.get_setting("gui/theme/custom")) as Theme

			if not has_theme_constant_override("v_separation"):
				add_theme_constant_override("v_separation", theme.get_constant("buildmenu_v_separation", "GridContainer"))
