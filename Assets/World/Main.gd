extends Node2D

class_name MainNode

@onready var game_context_manager: GameContextManager = %GameContextManager
@onready var treasury_timer: Timer = %TreasuryTimer
@onready var player_hud: Control = %PlayerHud2

func _ready():
  self.treasury_timer.timeout.connect(_on_TreasuryTimer_timeout)
  var finance_and_resource_overlay: FinanceAndResourceOverlay = self.player_hud.get_node("FinanceAndResourceOverlay")
  game_context_manager.context_changed.connect(finance_and_resource_overlay.on_context_changed)

func _on_TreasuryTimer_timeout() -> void:
  GameStats.treasury._on_treasury_timer_timeout(self.treasury_timer)
  self.player_hud.get_node("FinanceAndResourceOverlay/BalanceInfoButton").refresh()
