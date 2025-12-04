extends MarginContainer

@onready var cost_label: Label = $HBoxContainer/HBoxContainer/LabelEx
@onready var efficiency_label: Label = $HBoxContainer/HBoxContainer2/LabelEx

var selected_node: WorldThing2D = null:
	set(value):
		selected_node = value
		var building := value as Building2D
		if building != null:
			self.cost_label.text = str(building.cost)
