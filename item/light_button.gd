extends Node3D

var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var is_pressed = false
	for body in $Area3D.get_overlapping_bodies():
		is_pressed = is_pressed or body.is_in_group('can_press')
	active = is_pressed
	
	$On.visible = active
	$Off.visible = not active
	pass
