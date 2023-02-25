extends LabelEx
class_name GameSpeedLabel

func _ready() -> void:
	call_deferred("connect_game") # waiting for Global.Game to be set

func connect_game() -> void:
	Global.Game.connect("game_speed_changed", self, "_on_game_speed_changed")

func _on_game_speed_changed(new_game_speed: float) -> void:
	text = "%1.1fx" % new_game_speed
