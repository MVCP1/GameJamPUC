extends Node

func get_world():
	return get_tree().root.get_node('Main')
	
func get_player():
	return get_world().get_node('Player')
	
func get_camera():
	return get_world().get_node('Camera')
	
func get_mouse():
	return get_camera().getMousePosition()
	
func get_fairy():
	if get_world().get_node('Fairy'):
		return get_world().get_node('Fairy')
	else:
		return get_player()

