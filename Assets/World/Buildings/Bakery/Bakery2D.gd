extends WorldThing2D

class_name Bakery2D

func _ready():
  setup_components()

func setup_components() -> void:
  # get a list of all the child components
  var components: Array[BaseComponent]
  for child in self.get_children():
    if child is BaseComponent:
      components.append(child)
  # give all the components the list of all their neighboring components
  for component in components:
    component.set_components(components)
