tool
extends HBoxContainer

enum BalanceTypes {
	EXPENSE,
	INCOME,
	BUY,
	SELL,
	RESULT,
	
	SHIPS,
	TOOLS,
	WEAPONS
}

const BALANCE_TYPES = [
	preload("res://Assets/UI/Images/ResbarStats/expense.png"),
	preload("res://Assets/UI/Images/ResbarStats/income.png"),
	preload("res://Assets/UI/Images/ResbarStats/buy.png"),
	preload("res://Assets/UI/Images/ResbarStats/sell.png"),
	preload("res://Assets/UI/Images/ResbarStats/scales_icon.png"),
	
	preload("res://Assets/UI/Images/ResbarStats/ship_icon.png"),
	preload("res://Assets/UI/Images/ResbarStats/tools_icon.png"),
	preload("res://Assets/UI/Images/ResbarStats/weapons_icon.png")
]

export(BalanceTypes) var balance_type setget set_balance_type
export(int) var balance_value setget set_balance_value

onready var texture_rect = $TextureRect
onready var label = $Label

func set_balance_type(new_balance_type: int) -> void:
	if not is_inside_tree(): yield(self, "ready")
	if texture_rect == null: texture_rect = $TextureRect
	
	balance_type = new_balance_type
	texture_rect.texture = BALANCE_TYPES[balance_type]

func set_balance_value(new_balance_value: int) -> void:
	if not is_inside_tree(): yield(self, "ready")
	if label == null: label = $Label
	
	balance_value = new_balance_value
	
	var balance_sign = ""
	if balance_value >= 0:
		balance_sign = "+"
	
	label.text = "{0}{1}".format([balance_sign, balance_value])
