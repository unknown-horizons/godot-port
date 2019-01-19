extends Node

const GameObject = preload("gameObject.gd")

func _ready():
    pass

func get_objects_with_component(component):
    var found_components = Array()
    for child in get_children():
        if child is GameObject:
            if child.has_component(component):
                found_components.append(child)
    return found_components
