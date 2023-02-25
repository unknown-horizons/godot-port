extends LabelEx

func _ready() -> void:
	call_deferred("connect_game")#waiting for Global.Game to be set

func connect_game() -> void:
	Global.Game.connect("speed_changed",self,"_on_speed_changed")

func _on_speed_changed(new_speed:float) -> void:
	text = "%1.1fx" % new_speed
