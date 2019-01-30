extends ScrollContainer

var maps = [
	"dev",
	"foo",
	"fight-for-res",
	"bar",
	"full-house",
	"test-map-tiny",
	"big",
	"small",
	"long name",
]

func _ready():
	for mapName in maps:
		var button = Label.new()
		button.text = mapName
		$Container/VBoxContainer.add_child(button)