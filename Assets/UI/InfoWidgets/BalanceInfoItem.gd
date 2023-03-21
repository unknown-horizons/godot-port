@tool
extends HBoxContainer

enum BalanceType {
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

@export var balance_type: BalanceType : set = set_balance_type
@export var balance_value: int : set = set_balance_value

@onready var texture_rect = $TextureRect
@onready var label = $LabelEx

func set_balance_type(new_balance_type: int) -> void:
	if not is_inside_tree():
		await self.ready

	if texture_rect == null: texture_rect = $TextureRect

	balance_type = new_balance_type
	texture_rect.texture = BALANCE_TYPES[balance_type]

func set_balance_value(new_balance_value: int) -> void:
	if not is_inside_tree():
		await self.ready

	if label == null: label = $LabelEx

	balance_value = new_balance_value

	var balance_sign = ""
	if balance_value >= 0:
		balance_sign = "+"

	label.text = "{0}{1}".format([balance_sign, balance_value])
