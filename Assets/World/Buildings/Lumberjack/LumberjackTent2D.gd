extends ProductionBuilding2D

class_name Lumberjack2D

@export var unload_wood_time: int = 2

func _ready():
  self.setup_building()
  production_loop()

func production_loop():
  while self.number_of_output_products < self.max_storage_capacity:
    if self.number_of_intake_products <= 0:
      await wait_for_wood()
    await produce_wood()

func wait_for_wood():
  while true:
    await self.get_tree().create_timer(1).timeout
    if self.number_of_intake_products > 0:
      return

func produce_wood():
  if self.number_of_intake_products > 0:
    await self.get_tree().create_timer(self.processing_time).timeout
    self.number_of_intake_products -= 1
    self.number_of_output_products += 1
    self.show_tooltip_animation(1) # fire and forget

func unload_wood():
  await self.get_tree().create_timer(unload_wood_time).timeout
  self.number_of_intake_products += 1
