tool
extends VBoxContainer
class_name HSliderEx
# Horizontal slider with a description label and current value indicator

signal changed
signal value_changed(slider_value) # float

export(String) var description := "Unknown Slider:" setget set_description
#export(int) var tick_count setget set_tick_count
#export(bool) var ticks_on_borders := false setget set_ticks_on_borders
export(float) var min_value := 0.0 setget set_min_value
export(float) var max_value := 100.0 setget set_max_value
export(float) var step := 1.0 setget set_step
export(float) var value := 0.0 setget set_value

onready var label_desc := $HBoxContainer/LabelExDesc as Label
onready var label_value := $HBoxContainer/LabelExValue as Label
onready var slider := $HSlider as HSlider

func set_description(new_description: String) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	description = new_description

	label_desc.text = description

#func set_tick_count(new_tick_count: int) -> void:
#	if not is_inside_tree(): yield(self, "ready")
#	tick_count = clamp(new_tick_count, 0, max_value)
#
#	slider.tick_count = tick_count
#
#func set_ticks_on_borders(new_ticks_on_borders: bool) -> void:
#	if not is_inside_tree(): yield(self, "ready")
#	ticks_on_borders = new_ticks_on_borders
#
#	slider.ticks_on_borders = ticks_on_borders

func set_min_value(new_min_value: float) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	min_value = stepify(new_min_value, 0.01)

	if min_value > max_value:
		self.set_max_value(min_value)
		slider.max_value = min_value

	if min_value > value:
		self.value = min_value

	property_list_changed_notify()

	slider.min_value = min_value

func set_max_value(new_max_value: float) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	max_value = stepify(new_max_value, 0.01)

	if max_value < min_value:
		self.set_min_value(max_value)
		slider.min_value = max_value

	if max_value < value:
		self.value = max_value

	property_list_changed_notify()

	#slider.tick_count = max_value / 10
	slider.max_value = max_value

func set_step(new_step: float) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	step = stepify(new_step, 0.01)

	slider.step = step

func set_value(new_value: float) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	value = stepify(clamp(stepify(new_value, step), min_value, max_value), 0.01)

	slider.value = value
	label_value.text = str(value)

func _on_HSlider_changed() -> void:
	emit_signal("changed")

func _on_HSlider_value_changed(slider_value: float) -> void:
	value = slider_value
	label_value.text = str(value)
	emit_signal("value_changed", value)

func _on_ready() -> void:
	if not label_desc: label_desc = $HBoxContainer/LabelExDesc
	if not label_value: label_value = $HBoxContainer/LabelExValue
	if not slider: slider = $HSlider
