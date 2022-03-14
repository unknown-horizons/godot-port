tool
extends GridContainer

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			var theme := load(ProjectSettings.get_setting("gui/theme/custom")) as Theme

			if not has_constant_override("vseparation"):
				add_constant_override("vseparation", theme.get_constant("buildmenu_vseparation", "GridContainer"))
