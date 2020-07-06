tool
extends Control
class_name TabWidget

const log_book = preload("res://Assets/UI/Scenes/Logbook.tscn")

onready var body = $WidgetDetail/Body

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if body != null and body.rect_min_size.y < body.texture.get_size().y:
			# keep the size of one tile visible at all times
			body.rect_min_size.y = body.texture.get_size().y
	else:
		set_process(false)

func _on_LogBookButton_pressed():
	get_tree().root.add_child(log_book.instance())
	Audio.play_snd_click()
