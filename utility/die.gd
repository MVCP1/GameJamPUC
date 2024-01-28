extends Area3D

func _on_body_entered(body):
	if body == Game.get_player():
		Game.die()
	pass # Replace with function body.
