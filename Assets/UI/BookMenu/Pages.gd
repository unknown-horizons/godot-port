@tool
extends TabContainer

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PRE_SORT_CHILDREN:
			update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	if %Pages.get_child_count() > 0:
		return []
	else:
		return ["Node requires at least one BookMenuPage node " +
				"attached in order to be functional."]
