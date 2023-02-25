extends WidgetButton
class_name SpeedChangeButton

export (float) var speed_change = 0.0

func _pressed() -> void:
	._pressed()

	Global.Game.set_game_speed(Engine.time_scale+speed_change)
