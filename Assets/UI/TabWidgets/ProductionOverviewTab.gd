extends VBoxContainer

class_name ProductionOverviewTab

@onready var production_chains: VBoxContainer = self.get_node("ProductionChains")

func on_new_node_selected(node: WorldThing2D) -> void:
  # hide all production chains
  for child in production_chains.get_children():
    if child is ProductionChain:
      child.visible = false
  
  # turn on the needed ones
  var building_selected: Building2D = node as Building2D
  var production_chain_index: int = 0
  if building_selected != null:
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
      var slot_storage: SlotStorageComponent = building_selected.get_first_node_of_type(SlotStorageComponent) as SlotStorageComponent
      if slot_storage == null:
        if self.visible:
          push_warning("No slot storages found for: %s" % building_selected.name)
        continue
      production_chain.set_production_line(production_line, slot_storage)
