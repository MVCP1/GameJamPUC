extends StaticBody3D

@export var activators : Array[Node]
@export var time : float = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var total_act = len(activators)
	var act_n = 0
	for act in activators:
		if act.active:
			act_n += 1
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($CollisionShape3D, 'position', $End.position if act_n == total_act else $Start.position, time)
	pass
