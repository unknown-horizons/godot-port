tool
extends InventorySlot
class_name TradeSlot

const NONE_TEXTURE = preload("res://Assets/UI/Icons/Resources/none_gray.png")

onready var v_slider := $VSlider

func update_display() -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()

	.update_display()

	if not label.visible and not texture_rect2.visible:
		texture_rect.texture = NONE_TEXTURE
		texture_rect.show()
		v_slider.hide()

	else:
		texture_rect.show()
		label.show()
		texture_rect2.show()
		v_slider.show()

func _on_ready() -> void:
	if v_slider == null: v_slider = $VSlider
