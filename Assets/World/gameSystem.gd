extends Node

var physics_processed = false       
    
func _process(delta):
    if physics_processed:
        _after_physics_process()
        physics_processed = false
    
func _physics_process(delta):
    physics_processed = true
    
func _after_physics_process():
    pass