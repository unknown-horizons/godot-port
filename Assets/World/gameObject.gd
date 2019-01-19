extends Node

func _ready():
    pass

func has_component(name):
    return has_node("Components/" + name)
    
func get_component(name):
    if !has_component(name): # Check exists to keep the log error free.
        return null
    return get_node("Components/" + name)
    
func create_and_add_component(component_class, name):
    if has_component(name):
        return null
    var components = get_node("Components")
    var new_component = component_class.new()
    new_component.name = name
    components.add_child(new_component)
    return new_component
    
func _get(property):
    return get_component(property)