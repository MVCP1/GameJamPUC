extends Node

var current_level = 0
var volume = 0.0


func _process(_delta):
	if Input.is_action_pressed("esc"):
		get_tree().quit()

func next_level():
	current_level += 1
	if current_level == 4:
		get_tree().change_scene_to_file("res://UI/Scenes/menu.tscn")
	get_tree().change_scene_to_file("res://scene/level"+str(current_level)+".tscn")

	
func die():
	get_tree().reload_current_scene()

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

