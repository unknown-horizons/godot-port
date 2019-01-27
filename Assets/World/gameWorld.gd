extends Node

const GameObject = preload("gameObject.gd")
const GameSystem = preload("gameSystem.gd")

func _ready():
    for child in get_children():
        set_world_for_system_children(child)

func _process(delta):
    pass

func set_world_for_system_children(child):
    if child is GameSystem:
            child.world = self 
            
func get_objects_with_component(component):
    var found_objects = Array()
    for child in get_parent().get_children():
        if child is GameObject:
            if child.has_component(component):
                found_objects.append(child)
    return found_objects

func add_child(child):
    .add_child(child)
    set_world_for_system_children(child)
