@tool
extends VBoxContainer
class_name HSliderEx

## Horizontal slider with a description label and current value indicator.

signal changed
signal value_changed(slider_value: float)

@export var description: String = "Unknown Slider:" : set = set_description
#export var tick_count: int : set = set_tick_count
#export var ticks_on_borders: bool := false : set = set_ticks_on_borders
@export var min_value: float = 0.0 : set = set_min_value
@export var max_value: float = 100.0 : set = set_max_value
@export var step: float = 1.0 : set = set_step
@export var value: float = 0.0 : set = set_value

@onready var label_desc := $HBoxContainer/LabelExDesc as Label
@onready var label_value := $HBoxContainer/LabelExValue as Label
@onready var slider := $HSlider as HSlider

func set_description(new_description: String) -> void:
	if not is_inside_tree():
		await self.ready

	description = new_description

	label_desc.text = description

#func set_tick_count(new_tick_count: int) -> void:
#	if not is_inside_tree():
#		await self.ready
#
#	tick_count = clamp(new_tick_count, 0, max_value)
#
#	slider.tick_count = tick_count
#
#func set_ticks_on_borders(new_ticks_on_borders: bool) -> void:
#	if not is_inside_tree():
#		await self.ready
#
#	ticks_on_borders = new_ticks_on_borders
#
#	slider.ticks_on_borders = ticks_on_borders

func set_min_value(new_min_value: float) -> void:
	if not is_inside_tree():
		await self.ready

	min_value = snapped(new_min_value, 0.01)

	if min_value > max_value:
		self.set_max_value(min_value)
		slider.max_value = min_value

	if min_value > value:
		self.value = min_value

	notify_property_list_changed()

	slider.min_value = min_value

func set_max_value(new_max_value: float) -> void:
	if not is_inside_tree():
		await self.ready

	max_value = snapped(new_max_value, 0.01)

	if max_value < min_value:
		self.set_min_value(max_value)
		slider.min_value = max_value

	if max_value < value:
		self.value = max_value

	notify_property_list_changed()

	#slider.tick_count = max_value / 10
	slider.max_value = max_value

func set_step(new_step: float) -> void:
	if not is_inside_tree():
		await self.ready

	step = snapped(new_step, 0.01)

	slider.step = step

func set_value(new_value: float) -> void:
	if not is_inside_tree():
		await self.ready

	value = snapped(clamp(snapped(new_value, step), min_value, max_value), 0.01)

	slider.value = value
	label_value.text = str(value)

func _on_HSlider_changed() -> void:
	emit_signal("changed")

func _on_HSlider_value_changed(slider_value: float) -> void:
	value = slider_value
	label_value.text = str(value)
	emit_signal("value_changed", value)
