tool
extends Control
class_name TabWidget

const log_book = preload("res://Assets/UI/Scenes/Logbook.tscn")

onready var body = $WidgetDetail/Body
onready var ship_menu = preload("res://Assets/UI/Scenes/TabWidget/ShipMenu.tscn").instance()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if body != null and body.rect_min_size.y < body.texture.get_size().y:
			# keep the size of one tile visible at all times 
			body.rect_min_size.y = body.texture.get_size().y
	else:
		set_process(false)

func _on_LogBookButton_pressed():
	get_tree().root.add_child(log_book.instance())
	Audio.play_snd_click()
	
func _change_on_select(selected_units):
	if selected_units.size() == 1:
		var selected_unit = selected_units[0]
		# only one Unit, so probably only possible to build etc. if only one Unit selected
		if selected_unit.get_groups().find("ships") == 1: # Its a ship
			_set_detail_body(ship_menu)
			ship_menu.set_selected_ship(selected_unit)
			_set_detail_visibility(true)			
		if selected_units[0].get_groups().find("ships") != 1: # Its not a ship. Do something else
			pass
	elif selected_units.size() > 1: # multiple units selected, do something else
		pass
	pass
	
func _set_detail_body(new_detail_body):
	body = $WidgetDetail/Body
	body.replace_by(new_detail_body)
	
func _set_detail_visibility(visible):
	$WidgetDetail.visible = visible
