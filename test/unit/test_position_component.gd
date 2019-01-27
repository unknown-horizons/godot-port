extends "res://addons/gut/test.gd"

const PositionComponent = preload("res://Assets/World/components/position.gd")

var position

func before_each():
    position = PositionComponent.new()
    
func test_serializable_list_valid():
    gut.p("Test started")
    var serializable = position.get_serializable_fields()
    var is_array = typeof(serializable) == TYPE_ARRAY
    assert_true(is_array, "Expected serializable fields to be an array")
    if is_array:
        var property_list = position.get_property_list()
        var property_names = Array()
        for prop_dict in property_list:
            property_names.append(prop_dict["name"])            
        for field in serializable:
            assert_true(property_names.has(field), "Expected serializable fields to only contain actual fields")
    gut.p("Test ended")
