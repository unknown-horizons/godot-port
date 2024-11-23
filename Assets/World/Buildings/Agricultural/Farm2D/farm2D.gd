extends Node2D

@export_category("Farm")
@export var game_name: String = "Farm"
@export var production_time: int = 10
@export var max_storage_capacity: int = 10
@export var output_product: String
@export var needs_intake_poduct: bool = false

@onready var prod_timer: Timer = get_node("ProdTimer")
@onready var person: Person = get_node("Person")

var number_of_output_products = 0
var number_of_intake_products = 0




func _ready():
  var path = self.get_parent().get_path_to_dest(self.position, Vector2(0, 0))
  if path != null:
    person.path = path
  prod_timer.start(production_time)



func _on_timer_timeout():
  if needs_intake_poduct:
    if number_of_intake_products > 0:
      number_of_intake_products -= 1
    else:
      return

  if number_of_output_products < 10:
    number_of_output_products += 1
    

  if not person.is_moving:
    person.objects_carring["there"] = [output_product, min(number_of_output_products, person.max_carry_limit)]
    person.objects_carring["back"] = null
    number_of_output_products -= person.count_of_objects
    person.move()
