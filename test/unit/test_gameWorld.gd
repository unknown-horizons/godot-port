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
    
func test_get_objects_with_component_returns_all_components_with_name():
    var expected_objects = Array()
    var object
    object = given_map_has_object()
    object.create_and_add_component(Node, "Test")
    expected_objects.append(object)
    object = given_map_has_object()
    object.create_and_add_component(Node, "Test")
    expected_objects.append(object)
    object = given_map_has_object()
    object.create_and_add_component(Node, "Test_check")
    object = given_map_has_object()
    var returned_components = world.get_objects_with_component("Test")
    assert_true(typeof(returned_components) == TYPE_ARRAY, "Expected returned components to be an array")
    var expected_size = expected_objects.size()
    var returned_size = returned_components.size()
    var have_same_size = expected_size == returned_size
    assert_true(have_same_size, "Expected both arrays to have the same values")
    if have_same_size:
        for component in returned_components:
            assert_has(expected_objects, component, "Expected both arrays to have the same values")
    
func given_map_has_object():
    var object = GameObject.new()
    var components = Node.new()
    components.name = "Components"
    object.add_child(components)
    map.add_child(object)
    return object
    
func test_add_child_sets_world_for_systems():
    var system = GameSystem.new()
    assert_eq(system.world, null)
    world.add_child(system)    
    assert_eq(system.world, world)