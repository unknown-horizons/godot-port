extends Node2D

class_name MainNode

@onready var treasury_timer: Timer = %TreasuryTimer
@onready var player_hud: Control = %PlayerHud2

func _ready():
  self.treasury_timer.timeout.connect(_on_TreasuryTimer_timeout)

func _on_TreasuryTimer_timeout() -> void:
  GameStats.treasury._on_treasury_timer_timeout(self.treasury_timer)
  self.player_hud.get_node("BalanceInfoButton").refresh()
