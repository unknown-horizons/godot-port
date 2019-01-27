extends "res://Assets/World/gameSystem.gd"

const GameObject = preload("res://Assets/World/gameObject.gd")

func _process(delta):
    for game_object in world.get_objects_with_component("position"):
        var position = game_object.get_component("position")
        if position.modified:
            position.node.position = position.vector
            position.node.rotation_degrees = position.rotation
            position.modified = false
        else:
            position.vector = position.node.position
            position.rotation = position.node.rotation_degrees
