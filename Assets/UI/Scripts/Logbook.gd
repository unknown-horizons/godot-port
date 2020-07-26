tool
extends Control

export(int) var current_page setget set_current_page
#export(String) var caption_text := "This is a Book Title" setget set_caption_text
#export(String, MULTILINE) var body_text := "There is nothing written in your logbook yet!" setget set_body_text
export(Array, Array, String, MULTILINE) var pages := [["This is a Book Title", "There is nothing written in your logbook yet!"]] setget set_pages

onready var caption := $CenterContainer/TextureRect/MarginContainer/HBoxContainer/LeftPage/Caption
onready var body := $CenterContainer/TextureRect/MarginContainer/HBoxContainer/LeftPage/Body

onready var page_control := $CenterContainer/TextureRect/MarginContainer/HBoxContainer/LeftPage/PageControl

func _ready() -> void:
	update_book()

func set_current_page(new_current_page: int) -> void:
	current_page = clamp(new_current_page, 0, pages.size() - 1)
	update_book()

func update_book() -> void:
	update_text()
	update_page_control()

func update_text() -> void:
	if not is_inside_tree(): yield(self, "ready")
	
	if pages.size() > 0:
		caption.text = pages[current_page][0]
		body.text = pages[current_page][1]
	else:
		caption.text = ""
		body.text = ""

func update_page_control() -> void:
	if not is_inside_tree(): yield(self, "ready")
	
#	if pages.size() <= 1:
#		page_control.get_node("PrevButton").disabled = true
#		page_control.get_node("NextButton").disabled = true
	page_control.get_node("PrevButton").disabled = true
	page_control.get_node("NextButton").disabled = true
	if pages.size() > 1:
		if 0 < current_page:
			page_control.get_node("PrevButton").disabled = false
		if current_page < pages.size() - 1:
			page_control.get_node("NextButton").disabled = false

#func set_caption_text(new_caption_text: String) -> void:
#	caption_text = new_caption_text
#
#	if caption != null:
#		caption.text = caption_text
#
#func set_body_text(new_body_text: String) -> void:
#	body_text = new_body_text
#
#	if body != null:
#		body.text = body_text

func set_pages(new_pages: Array) -> void:
#	var old_pages = pages
	pages = new_pages
#	if pages.size() > old_pages.size(): # new page has been added
#		pages[pages.size() - 1] = ["", ""] # always have Array.size == 2
	for page in pages:
		if page.size() != 2:
			page.resize(2)
	
	if not is_inside_tree(): return # when setter is invoked too early
	update_book()

func _on_PrevButton_pressed() -> void:
	self.current_page -= 1

func _on_NextButton_pressed() -> void:
	self.current_page += 1

func _on_OKButton_pressed() -> void:
	queue_free()
