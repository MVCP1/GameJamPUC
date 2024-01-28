extends Area3D

@export var activators : Array[Node]

var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Closed.visible = not open
	$Open.visible = open
	
	var total_act = len(activators)
	var act_n = 0
	for act in activators:
		if act.active:
			act_n += 1
	if(act_n == total_act):
		open = true
	print(open, $Open.visible, $Closed.visible)
	pass


func _on_body_entered(body):
	if body == Game.get_player() and open:
		Game.next_level()
	pass # Replace with function body.
