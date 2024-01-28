extends Node3D

var active = false
var fairy_distance = 0.5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	active = Game.get_fairy().global_position.distance_to($Off.global_position) <= fairy_distance
	
	$On.visible = active
	$Off.visible = not active
	pass
