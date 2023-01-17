extends MinimapLayer
class_name MinimapTerrainLayer


export var water_color : Color = Color.blue
export var ground_color : Color = Color.brown
export var water_item : int = 12


var minimap : Minimap
var terrain_image : Image
var terrain_texture : ImageTexture


func _draw():
	draw_texture_rect(terrain_texture, Rect2(Vector2(0, 0), minimap.size), false)


func draw_layer():
	minimap = get_parent() as Minimap
	
	terrain_image = Image.new()
	terrain_image.create(minimap.size.x, 
		minimap.size.y, 
		false, 
		Image.FORMAT_RGBA8)
	terrain_image.fill(ground_color)
	terrain_image.lock()
	
	terrain_texture = ImageTexture.new()
	terrain_texture.create_from_image(terrain_image)
	
	#var draw_sea_tiles_thread := Thread.new()
	#draw_sea_tiles_thread.start(self, "draw_sea_tiles")
	draw_sea_tiles()


func draw_sea_tiles():
	# item number 12 is deep ocean in current mesh library, if mesh library is changed in the future
	# this value needs to be updated
	var deep_ocean_terrain_index := 12
	for cell in minimap.terrain.get_used_cells_by_item(deep_ocean_terrain_index):
		terrain_image.set_pixelv(Vector2(cell.x, cell.z), water_color)
		
	terrain_texture.create_from_image(terrain_image)
	update()
