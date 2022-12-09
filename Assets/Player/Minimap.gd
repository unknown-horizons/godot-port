extends Control


export var water_color : Color = Color.blue
export var ground_color : Color = Color.brown
export var water_item : int = 12
export var minimap_size : Vector2 = Vector2(200, 200)


var minimap_image : Image
var minimap_texture : ImageTexture


func _ready():
	self.rect_size = minimap_size
	self.rect_pivot_offset = Vector2(minimap_size.x / 2, minimap_size.y / 2)
	
	minimap_image = Image.new()
	minimap_image.create(minimap_size.x, minimap_size.y, false, Image.FORMAT_RGBA8)
	minimap_image.fill(ground_color)
	minimap_image.lock()
	
	minimap_texture = ImageTexture.new()
	minimap_texture.create_from_image(minimap_image)
	
	Thread.new().start(self, "initialize_minimap")


func _draw():
	draw_texture_rect(minimap_texture, Rect2(Vector2(0, 0), minimap_size), false)


func initialize_minimap():
	var terrain : GridMap = get_tree().current_scene.get_node("AStarMap/Terrain") as GridMap
	
	for cell in terrain.get_used_cells_by_item(12):
		minimap_image.set_pixelv(Vector2(cell.x, cell.z), water_color)
		
	minimap_texture.create_from_image(minimap_image)
	print("Finished setting up minimap")
	update()
