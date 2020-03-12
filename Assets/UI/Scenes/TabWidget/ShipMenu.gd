tool
extends Control
class_name ShipMenu

const inventory_slot_scene = preload("res://Assets/UI/Scenes/InventorySlot.tscn")
const warehouse_scene = preload("res://Assets/World/Buildings/Citizens/Warehouse/Warehouse.tscn")
onready var grid_container = $ShipMenu/InvMarginBox/InvGridContainer
onready var name_caption = $ShipMenu/Caption
onready var selected_ship = null

func set_selected_ship(ship):
	selected_ship = ship
	_set_caption(selected_ship.name)
	_add_resource_slots(selected_ship.num_of_slots)
	
func _on_ColoniseButton_pressed():
	pass
	
func _set_caption(new_caption):
	name_caption.text = new_caption
	
func _add_resource_slots(num_slots):
	# first remove all slots from previous selection (if any)
	if grid_container.get_child_count() > 0:
		for n in grid_container.get_children():
			grid_container.remove_child(n)
			n.queue_free()
	# add new slots
	for idx in range(num_slots):
		var inventory_slot = inventory_slot_scene.instance()
		inventory_slot.set_resource_type(idx)
		grid_container.add_child(inventory_slot)
	
func _set_resource_in_slot():
	pass
	
func _ready():
	pass # Replace with function body.
