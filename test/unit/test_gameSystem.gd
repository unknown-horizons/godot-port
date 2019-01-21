extends "res://addons/gut/test.gd"

const GameWorld = preload("res://Assets/World/gameWorld.gd")
const GameObject = preload("res://Assets/World/gameObject.gd")
const GameSystem = preload("res://Assets/World/gameSystem.gd")

var world
var map

func before_each():
    map = Node.new()
    world = GameWorld.new()
    map.add_child(world)
    