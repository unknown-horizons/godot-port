extends VBoxContainer

@onready var tab_container: TabContainer = $"../VBoxContainer/TabContainer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  for child in self.get_children():
    var child_btn = child as Button
    if child_btn:
      child_btn.pressed.connect(func(): _on_button_pressed(child_btn))

func _on_button_pressed(btn: Button) -> void:
  prints("Button pressed:", btn.text)
  var btn_name := btn.text.strip_edges()
  for i in range(tab_container.get_tab_count()):
    var tab_widget: Control = tab_container.get_tab_control(i)
    if tab_widget.name == btn_name:
      tab_container.set_current_tab(i)
      break
