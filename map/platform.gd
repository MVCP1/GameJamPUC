extends Node3D

@export var time = 3
@export var fairy_distance = 2
@export var likes_fairy = true
var forward = true
var tween
var active

# Called when the node enters the scene tree for the first time.
func _ready():
	move()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.get_mouse().distance_to($box.global_position) > fairy_distance:
		active = not likes_fairy
	else:
		active = likes_fairy
	if active:
		tween.play()
		$box/CollisionShape3D/MeshInstance3D.material_override.albedo_color = Color(0,1,0)
	else:
		tween.pause()
		$box/CollisionShape3D/MeshInstance3D.material_override.albedo_color = Color(1,0,0)
	pass


func move():
	tween = create_tween()
	#tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property($box, 'global_position', $End.global_position if forward else $Start.global_position, time)
	tween.connect("finished", on_tween_finished)
	
func on_tween_finished():
	forward = not forward
	move()
