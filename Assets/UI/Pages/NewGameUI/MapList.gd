extends ItemList

## [b]❗TODO: Make this dynamic.[/b]
var maps = {
	#"WorldDev": preload("res://Assets/World/WorldDev.tscn"),
	"WorldDev": preload("res://Assets/World/WorldDev2D.tscn"),
	"WorldDev_simple": preload("res://Assets/World/WorldDev2D_simple.tscn"),
	# "World": preload("res://Assets/World/World.tscn"),
}

func _ready() -> void:
	Global.map = maps["WorldDev"]

	var index = 0
	for map in maps:
		add_item(map)
		if maps[map] == Global.map:
			select(index)
		index += 1

func _on_ItemList_item_selected(index: int) -> void:
	Global.map = maps[get_item_text(index)]
