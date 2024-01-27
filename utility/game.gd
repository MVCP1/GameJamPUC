extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_player():
	return get_tree().root.get_node('Main').get_node('Player')
	
func get_camera():
	return get_tree().root.get_node('Main').get_node('Camera')
	
func get_mouse():
	return get_camera().getMousePosition()
	
func get_fairy():
	return get_tree().root.get_node('Main').get_node('Fairy')
