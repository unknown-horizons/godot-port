extends WidgetButton
class_name GameSpeedChangeButton

@export var game_speed_change: float = 0.0

func _pressed() -> void:
	super()

	Global.Game.set_game_speed(Engine.time_scale + game_speed_change)
