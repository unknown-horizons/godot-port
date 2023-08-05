@tool
extends InventorySlot
class_name TradeSlot

const NONE_TEXTURE = preload("res://Assets/UI/Icons/Resources/none_gray.png")

@onready var v_slider := $VSlider

func update_display() -> void:
	if not is_inside_tree():
		await self.ready

	super()

	if not label.visible and not texture_rect.visible:
		resource_item.texture = NONE_TEXTURE
		resource_item.show()
		v_slider.hide()

	else:
		resource_item.show()
		label.show()
		texture_rect.show()
		v_slider.show()
