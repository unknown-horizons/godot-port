extends "res://Assets/World/gameObject.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here    
    $"Components/position".node = get_parent().get_node("WorldPlace")

# func _process(delta):
    # Called every frame. Delta is time since last frame.
    # Update game logic here.
    # pass