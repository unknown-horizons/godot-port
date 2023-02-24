tool
extends Control

const Global = preload("res://Assets/World/Global.gd")

export(int) var number_inputs := 1 setget set_number_inputs

export(Global.ResourceType) var input_one_type setget set_input_one_type
export(Global.ResourceType) var input_two_type setget set_input_two_type
export(Global.ResourceType) var input_three_type setget set_input_three_type
export(Global.ResourceType) var output_type setget set_output_type

export(int) var input_one_value setget set_input_one_value
export(int) var input_two_value setget set_input_two_value
export(int) var input_three_value setget set_input_three_value
export(int) var output_value setget set_output_value

export(int) var input_one_storage_limit := 10 setget set_input_one_storage_limit
export(int) var input_two_storage_limit := 10 setget set_input_two_storage_limit
export(int) var input_three_storage_limit := 10 setget set_input_three_storage_limit
export(int) var output_storage_limit := 10 setget set_output_storage_limit

onready var vbox_container := find_node("VBoxContainer")
onready var top_section := find_node("TopSection")
onready var middle_section := find_node("MiddleSection")
onready var arrow_start := find_node("ArrowStart")
onready var bottom_section := find_node("BottomSection")

onready var input_one := find_node("InputOne") as InventorySlot
onready var input_two := find_node("InputTwo") as InventorySlot
onready var input_three := find_node("InputThree") as InventorySlot
onready var output := find_node("Output") as InventorySlot

func set_number_inputs(new_number_inputs: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	number_inputs = clamp(new_number_inputs, 0, 3) as int

	match number_inputs:
		0: _set_inputs(false, false, false)
		1: _set_inputs(false, true, false)
		2: _set_inputs(true, false, true)
		3: _set_inputs(true, true, true)

func set_input_one_type(new_input_one_type: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	input_one.resource_type = new_input_one_type
	input_one_type = input_one.resource_type

func set_input_two_type(new_input_two_type: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	input_two.resource_type = new_input_two_type
	input_two_type = input_two.resource_type

func set_input_three_type(new_input_three_type: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	input_three.resource_type = new_input_three_type
	input_three_type = input_three.resource_type

func set_output_type(new_output_type: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	output.resource_type = new_output_type
	output_type = output.resource_type

func set_input_one_value(new_input_one_value: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	input_one.resource_value = new_input_one_value
	input_one_value = input_one.resource_value

	property_list_changed_notify()

func set_input_two_value(new_input_two_value: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	input_two.resource_value = new_input_two_value
	input_two_value = input_two.resource_value

	property_list_changed_notify()

func set_input_three_value(new_input_three_value: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	input_three.resource_value = new_input_three_value
	input_three_value = input_three.resource_value

	property_list_changed_notify()

func set_output_value(new_output_value: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	output.resource_value = new_output_value
	output_value = output.resource_value

	property_list_changed_notify()

func set_input_one_storage_limit(new_input_one_storage_limit: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	input_one.storage_limit = new_input_one_storage_limit
	input_one_value = input_one.resource_value
	input_one_storage_limit = input_one.storage_limit

	property_list_changed_notify()

func set_input_two_storage_limit(new_input_two_storage_limit: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	input_two.storage_limit = new_input_two_storage_limit
	input_two_value = input_two.resource_value
	input_two_storage_limit = input_two.storage_limit

	property_list_changed_notify()

func set_input_three_storage_limit(new_input_three_storage_limit: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	input_three.storage_limit = new_input_three_storage_limit
	input_two_value = input_two.resource_value
	input_three_storage_limit = input_three.storage_limit

	property_list_changed_notify()

func set_output_storage_limit(new_output_storage_limit: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	output.storage_limit = new_output_storage_limit
	output_storage_limit = output.storage_limit

	property_list_changed_notify()

func _set_input_one(enabled: bool) -> void:
	top_section.visible = enabled

func _set_input_two(enabled: bool) -> void:
	input_two.modulate.a = 1 if enabled else 0
	arrow_start.visible = enabled

func _set_input_three(enabled: bool) -> void:
	bottom_section.visible = enabled

func _set_inputs(input_one: bool, input_two: bool, input_three: bool) -> void:
	_set_input_one(input_one)
	_set_input_two(input_two)
	_set_input_three(input_three)

	update()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAW:
			if not is_inside_tree(): yield(self, "ready"); _on_ready()

			# Reset to minimum size first
			rect_min_size = middle_section.rect_size
			vbox_container.rect_size = rect_min_size

			# Then expand to necessary size
			rect_min_size = vbox_container.rect_size

			# Control node cannot expand automatically to min size, so force it
			rect_size = rect_min_size

			property_list_changed_notify()

func _on_ready() -> void:
	if not vbox_container: vbox_container = find_node("VBoxContainer")
	if not top_section: top_section = find_node("TopSection")
	if not middle_section: middle_section = find_node("MiddleSection")
	if not arrow_start: arrow_start = find_node("ArrowStart")
	if not bottom_section: bottom_section = find_node("BottomSection")

	if not input_one: input_one = find_node("InputOne")
	if not input_two: input_two = find_node("InputTwo")
	if not input_three: input_three = find_node("InputThree")
	if not output: output = find_node("Output")
