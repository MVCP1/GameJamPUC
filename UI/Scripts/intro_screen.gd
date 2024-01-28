extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
		
		$"Made wGodot".hide()
		$PiramutabaTeam.show()
		await get_tree().create_timer(1.5).timeout
		$AnimationPlayer.play("Fade In")
		
		await get_tree().create_timer(3).timeout
		
		$AnimationPlayer.play("Fade Out")
		
		await get_tree().create_timer(4).timeout
		$"Made wGodot".show()
		$ColorRect2.show()
		$PiramutabaTeam.hide()
		$AnimationPlayer.play("Fade In")
		await get_tree().create_timer(4).timeout
		$AnimationPlayer.play("Fade Out")
		await get_tree().create_timer(4).timeout
		get_tree().change_scene_to_file("res://UI/Scenes/menu.tscn")
		pass
	
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://UI/Scenes/menu.tscn")
		
		
		

