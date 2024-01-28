extends Node3D

@export var always_active = false
@export var activators : Array[Node]
@export var time: float = 3
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
func _process(_delta):
	var total_act = len(activators)
	if total_act > 0:
		var act_n = 0
		for act in activators:
			if act.active:
				act_n += 1
		active = act_n == total_act
	else:
		if Game.get_fairy().global_position.distance_to($box.global_position) > fairy_distance:
			active = not likes_fairy
		else:
			active = likes_fairy
	if active or always_active:
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
