extends WidgetButton
class_name GameSpeedChangeButton

export(float) var game_speed_change = 0.0

func _pressed() -> void:
	._pressed()

	Global.Game.set_game_speed(Engine.time_scale + game_speed_change)
