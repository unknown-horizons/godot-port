extends "res://addons/gut/test.gd"

const GameWorld = preload("res://Assets/World/gameWorld.gd")
const GameObject = preload("res://Assets/World/gameObject.gd")
const PositionComponent = preload("res://Assets/World/components/position.gd")
const MovementSytem = preload("res://Assets/World/systems/movement.gd")

var world
var map
var position
var movement_system
var test_object


func before_each():
    map = Node.new()
    world = GameWorld.new()
    map.add_child(world)
    test_object = GameObject.new()
    var components = Node.new()
    components.name = "Components"
    test_object.add_child(components)
    map.add_child(test_object)
    position = test_object.create_and_add_component(PositionComponent, "position")
    movement_system = MovementSytem.new()
    world.add_child(movement_system)
    
func test_process_sets_node2d_values_when_component_modified():
    gut.p("Test started")
    var node = Node2D.new()
    map.add_child(node)
    node.position.x = 0
    node.position.y = 0    
    node.rotation_degrees = 0
    position.node = node
    position.vector = node.position
    position.rotation = node.rotation_degrees
    var test_x = 100.0
    var test_angle = 45.0
    position.vector.x = test_x
    position.rotation = test_angle
    position.modified = true
    gut.simulate(map, 1, .1)
    assert_eq(node.position.x, test_x, "Expected position to have been updated")
    assert_eq(node.rotation_degrees, test_angle, "Expected rotation to have been updated")
    assert_false(position.modified, "Expected modified to have been reset")
    gut.p("Test ended")  
    
func test_process_sets_component_values_to_node2d_if_component_not_modified():
    gut.p("Test started")
    var node = Node2D.new()
    map.add_child(node)
    node.position.x = 0
    node.position.y = 0    
    node.rotation_degrees = 0
    position.node = node
    position.vector = node.position
    position.rotation = node.rotation_degrees
    var test_y = 150.0
    var test_angle = 225.0
    node.position.y = test_y
    node.rotation_degrees = test_angle
    gut.simulate(map, 1, .1)
    assert_eq(position.vector.y, test_y, "Expected position to have been updated")
    assert_eq(position.rotation, test_angle, "Expected rotation to have been updated")
    gut.p("Test ended")
    
func test_process_sets_spatial_values_when_component_modified():
    gut.p("Test started")
    var spatial = Spatial.new()
    map.add_child(spatial)
    spatial.translation.x = 0.0
    spatial.translation.y = 0.0
    spatial.translation.z = 0.0
    position.node = spatial
    position.vector = Vector2(spatial.translation.x, spatial.translation.y)
    position.rotation = spatial.rotation_degrees.y
    var test_x = 100.0
    var test_y = 150.0
    var test_angle = 45.0
    position.vector.x = test_x
    position.vector.y = test_y
    position.rotation = test_angle
    position.modified = true
    gut.simulate(map, 1, .1)
    assert_eq(spatial.translation.x, test_x, "Expected position to have been updated")
    assert_eq(spatial.translation.y, test_y, "Expected position to have been updated")
    assert_eq(spatial.rotation_degrees.y, test_angle, "Expected rotation to have been updated")
    assert_false(position.modified, "Expected modified to have been reset")
    gut.p("Test ended")

func test_process_sets_component_values_to_spatial_if_component_not_modified():
    gut.p("Test started")
    var spatial = Spatial.new()
    map.add_child(spatial)
    position.node = spatial
    position.vector = Vector2(spatial.translation.x, spatial.translation.y)
    position.rotation = spatial.rotation_degrees.y
    var test_x = 100.0
    var test_y = 150.0
    var test_angle = 45.0
    spatial.translation.x = test_x
    spatial.translation.y = test_y
    spatial.rotation_degrees.y = test_angle
    gut.simulate(map, 1, .1)
    assert_eq(position.vector.x, test_x, "Expected position to have been updated")
    assert_eq(position.vector.y, test_y, "Expected position to have been updated")
    assert_eq(position.rotation, test_angle, "Expected rotation to have been updated")
    gut.p("Test ended")    
