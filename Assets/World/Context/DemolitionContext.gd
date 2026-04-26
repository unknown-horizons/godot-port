extends BaseContext
## The DemolitionContext is responsible for demolishing buildings.

class_name DemolitionContext

@export var demolition_cursor: Texture2D = preload("res://Assets/UI/Images/Cursors/cursor_tear.png")

@onready var built_tilemap: BuiltTileMap = %BuiltTileMap

var previous_mouse_cell: Vector2i

func context_entered() -> void:
	Input.set_custom_mouse_cursor(self.demolition_cursor)
	# set default mouse cell
	var mouse_cell := self.built_tilemap.local_to_map(self.built_tilemap.get_global_mouse_position())
	self.previous_mouse_cell = mouse_cell

func context_exited() -> void:
	Input.set_custom_mouse_cursor(null)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_demolish"):
		self.game_context_manager.current_context = self
		return

	if self.is_active:
		var mouse_cell := self.built_tilemap.local_to_map(self.built_tilemap.get_global_mouse_position())
		var mouseButtonEvent := event as InputEventMouseButton
		if mouseButtonEvent != null:
			if mouseButtonEvent.button_index == MOUSE_BUTTON_LEFT and mouseButtonEvent.pressed:
				self.demolish(mouse_cell)

		if event.is_action_pressed("cancel"):
			self.game_context_manager.current_context = null

		if event is InputEventMouseMotion:
			if mouse_cell != self.previous_mouse_cell:
				self.previous_mouse_cell = mouse_cell
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					self.demolish(mouse_cell)

func demolish(cell_clicked: Vector2i) -> void:
	var building: Building2D = self.built_tilemap.building_position_to_building.get(cell_clicked, null)
	if building != null:
		if building.baseclass in ["nature.ResourceDeposit", "nature.Fish"]:
			return # do not demolish resource deposits
	self.built_tilemap.demolish(cell_clicked)
