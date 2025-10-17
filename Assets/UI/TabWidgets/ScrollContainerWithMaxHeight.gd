@tool

extends ScrollContainer

@onready var parent_container = $".."
@onready var scroll = $"."
@onready var content = self.get_child(0)

func _ready() -> void:
  var viewport = self.get_viewport();
  viewport.size_changed.connect(adjust_scroll_height)
  content.minimum_size_changed.connect(adjust_scroll_height)
  adjust_scroll_height()

func adjust_scroll_height():
  # print(self.get_viewport_rect())
  # Get screen or parent height
  var screen_height = parent_container.get_viewport_rect().size.y
  var top_position = scroll.global_position.y
  var extra_height = (parent_container.global_position.y + parent_container.size.y) - (scroll.global_position.y + scroll.size.y)
  var available_height = screen_height - top_position - extra_height
  # print(screen_height, " ", top_position, " ", extra_height, " ", available_height)

  # Measure content height
  var content_height = content.get_combined_minimum_size().y

  # Set scroll container height (grow until bottom, then scroll)
  scroll.custom_minimum_size.y = min(content_height, available_height)
