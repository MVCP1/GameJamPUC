extends Node

func get_player():
	return get_tree().root.get_node('Main').get_node('Player')
	
func get_camera():
	return get_tree().root.get_node('Main').get_node('Camera')
	
func get_mouse():
	return get_camera().getMousePosition()
	
func get_fairy():
	return get_tree().root.get_node('Main').get_node('Fairy')
