extends VBoxContainer

class_name ProductionOverviewTab

@onready var production_chains: VBoxContainer = self.get_node("ProductionChains")

var selected_node: WorldThing2D = null:
  set(value):
    selected_node = value
    on_new_selected_node(value)

func on_new_selected_node(node: WorldThing2D) -> void:
  for child in self.get_children():
    if "selected_node" in child:
      child.selected_node = node
  
  # hide all production chains
  for child in production_chains.get_children():
    if child is ProductionChain:
      child.visible = false
  
  var building_selected: Building2D = node as Building2D
  if building_selected != null:
    # turn on the needed ones
    var production_chain_index: int = 0
    for production_line: ProductionLineComponent in building_selected.get_all_nodes_of_type(ProductionLineComponent):
      # get the next production chain
      var production_chain: ProductionChain = production_chains.get_child(production_chain_index) as ProductionChain
      production_chain_index += 1
      while production_chain == null:
        if production_chain_index >= production_chains.get_child_count():
          push_error("The amount of production lines is more the the amount of chains for: %s" % building_selected.name)
          break
        production_chain = production_chains.get_child(production_chain_index)
        production_chain_index += 1
      production_chain.visible = true
      production_chain.set_production_line(production_line, building_selected)
