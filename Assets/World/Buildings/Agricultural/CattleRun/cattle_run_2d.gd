extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

  pass

func on_mouse_hovered():
  $AnimatedSprite2D.material.set_shader_parameter("width", 3)

func on_mouse_unhovered():
  $AnimatedSprite2D.material.set_shader_parameter("width", 0)
