extends TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_tint_progress(Color.WHITE)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		value += 1
	else:
		value -= 1
	if value < 15:
		var tween = get_tree().create_tween()
		tween.tween_property($".", "tint_progress", Color.WHITE, 0.2).set_trans(Tween.TRANS_SINE)
	elif  value > 15 and value < 50:
		var tween = get_tree().create_tween()
		tween.tween_property($".", "tint_progress", Color.YELLOW, 0.2).set_trans(Tween.TRANS_SINE)
	elif value > 50 and value < 80:
		var tween = get_tree().create_tween()
		tween.tween_property($".", "tint_progress", Color.ORANGE, 0.2).set_trans(Tween.TRANS_SINE)
	elif value > 80 :
		var tween = get_tree().create_tween()
		tween.tween_property($".", "tint_progress", Color.RED, 0.2).set_trans(Tween.TRANS_SINE)

