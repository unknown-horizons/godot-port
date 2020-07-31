extends ItemList

# TODO: Make this dynamic
var maps = {
	"WorldTown": preload("res://Assets/World/WorldTown.tscn"),
	"WorldTest": preload("res://Assets/World/WorldTest.tscn"),
	"World": preload("res://Assets/World/World.tscn"),
}

func _ready() -> void:
	var index = 0
	for map in maps:
		add_item(map)
		if maps[map] == Global.map:
			select(index)
		index += 1

func _on_ItemList_item_selected(index: int) -> void:
	Global.map = maps[get_item_text(index)]
