extends "res://Assets/World/gameSystem.gd"

const GameObject = preload("res://Assets/World/gameObject.gd")

func _process(delta):
    for game_object in world.get_objects_with_component("position"):
        var position = game_object.get_component("position")
        var node = position.node
        if node == null:
            return
        if position.modified:
            if node is Node2D:
                node.position = position.vector
                node.rotation_degrees = position.rotation
            elif node is Spatial:
                node.translation.x = position.vector.x
                node.translation.y = position.vector.y
                node.rotation_degrees.y = position.rotation
            position.modified = false
        else:
            if node is Node2D:
                position.vector = node.position
                position.rotation = node.rotation_degrees
            elif node is Spatial:
                position.vector = Vector2(node.translation.x, node.translation.y)
                position.rotation = node.rotation_degrees.y
