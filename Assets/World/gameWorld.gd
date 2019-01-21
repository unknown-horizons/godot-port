extends Node

const GameObject = preload("gameObject.gd")
const GameSystem = preload("gameSystem.gd")

func _ready():
    pass

func _process(delta):
    pass

func get_objects_with_component(component):
    var found_components = Array()
    for child in get_parent().get_children():
        if child is GameObject:
            if child.has_component(component):
                found_components.append(child)
    return found_components

func add_child(child):
    .add_child(child)
    if child is GameSystem:
        child.world = self 