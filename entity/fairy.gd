extends CharacterBody3D

const maxSpeed = 15
const slowSpeed = 5
const minSpeed = 1

var direction = Vector3(0,0,0)
var distance
const distance_min = 0.1

const min_size = 0.18
const max_size = 0.25

const max_y_offset = 1

const max_light = 5.0
const min_light = 0.5

var can_move = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Energy.value = 100.0
	$MeshInstance3D/OmniLight3D.light_energy = max_light
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('click'):
		can_move = not can_move
		
	var percent = ($Energy.value/$Energy.max_value)
	$MeshInstance3D.scale = Vector3(1,1,1)*clamp(max_size*percent, min_size, max_size)
	$MeshInstance3D/OmniLight3D.light_energy = clamp(max_light*percent, min_light, max_light)
	
	if can_move:
		var mouse = Game.get_mouse() + Vector3(0,clamp(max_y_offset*percent, 0, max_y_offset),0)
		distance = global_position.distance_to(mouse)
		if(distance > distance_min):
			direction += (mouse - global_position).normalized()*2
			direction = direction.normalized()
			var speed = clamp(distance, minSpeed, slowSpeed+(maxSpeed-slowSpeed)*percent)
			velocity = direction*speed
			move_and_slide()
			add_charge(-speed)
	pass

func add_charge(multiplier:float=1):
	$Energy.value += $Energy.step*multiplier
