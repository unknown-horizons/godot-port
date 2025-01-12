extends TileMapLayer



func highlight_road(cells):
  self.clear()

  #if is_buildable:
    #self.material.next_pass.
#
  #else:
    #pass

  self.set_cells_terrain_connect(cells, 0, 0, false)
