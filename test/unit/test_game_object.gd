extends "res://addons/gut/test.gd"

const GameObject = preload("res://assets/world/game_object.gd")

var node;
var components;

func before_each():
    node = Node.new()
    components = Node.new()
    components.name = "Components"
    node.add_child(components)
    node.set_script(GameObject)  
    
func test_has_returns_true_on_existing_component():
    var test_component = Node.new()
    test_component.name = "Test"
    components.add_child(test_component)
    assert_true(node.has_component("Test"), "Expected has_component to return true")

func test_has_returns_false_for_non_existing_component():
    assert_false(node.has_component("Test"), "Expected has_component to return false")

func test_get_returns_existing_component():
    var test_component = Node.new()
    test_component.name = "Test"
    components.add_child(test_component)
    assert_eq(node.get_component("Test"), test_component, "Expected get_component to return the correct component")

func test_get_returns_null_for_non_existing_component():
    assert_eq(node.get_component("Test"), null, "Expected get_component to return null")
    
func test_create_and_add_adds_non_existing_component():
    var component = node.create_and_add_component(Node, "Test")
    assert_ne(component, null, "Expected non null return value")
    assert_true(node.is_a_parent_of(component), "Expected value to be a child of Components")

func test_create_and_add_does_not_add_if_component_already_exists():
    var test_component = Node.new()
    test_component.name = "Test"
    components.add_child(test_component)
    var component = node.create_and_add_component(Node, "Test")
    assert_eq(component, null, "Expected null return value")
    assert_true(node.is_a_parent_of(test_component), "Expected previous component to still be a child of Components")

func test_get_operator_returns_existing_component():
    var test_component = Node.new()
    test_component.name = "Test"
    components.add_child(test_component)
    assert_eq(node.Test, test_component, "Expected GameObject.Test to return the correct component")
