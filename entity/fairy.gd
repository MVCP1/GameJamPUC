extends CharacterBody3D

@export var toggle_outline_radius: float = 3.5

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

const pulse_light_multiplier = 2
var charging_pulse = false
const min_pulse_charge = 50
var can_update_light = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$Energy.value = 100.0
	$MeshInstance3D/OmniLight3D.light_energy = max_light
	$ToggleOutlineArea/CollisionShape3D.shape.radius = toggle_outline_radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed('l_click'):
		can_move = not can_move
	if Input.is_action_pressed('r_click'):
		charging_pulse = true
	if Input.is_action_just_released('r_click'):
		pulse()
		
	var percent = ($Energy.value/$Energy.max_value)
	$MeshInstance3D.scale = Vector3(1,1,1)*clamp(max_size*percent, min_size, max_size)
		
	if(can_update_light):
		if(charging_pulse):
			var pulse_percent = 1 - $Pulse.value/$Pulse.max_value
			$MeshInstance3D/OmniLight3D.light_color = Color(1, pulse_percent, pulse_percent)
			$Pulse.value += $Pulse.step
			$MeshInstance3D/OmniLight3D.light_energy = clamp(max_light*pulse_percent, min_light, max_light)
		else:
			$MeshInstance3D/OmniLight3D.light_color = Color(1, 1, 1)
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

func pulse():
	if($Pulse.value >= min_pulse_charge):
		can_update_light = false
		var pulse_multiplier = $Pulse.value/min_pulse_charge
		var pulse_percent = $Pulse.value/$Pulse.max_value
		print(pulse_multiplier)
		$Area3D/CollisionShape3D.scale = Vector3(1,1,1)*pulse_multiplier
		var grow_tween = create_tween()
		#grow_tween.set_ease(Tween.EASE_OUT)
		grow_tween.set_trans(Tween.TRANS_ELASTIC)
		grow_tween.tween_property($MeshInstance3D/OmniLight3D, 'light_energy',  max_light*pulse_light_multiplier*pulse_percent, 0.1)
		#$MeshInstance3D/OmniLight3D.light_energy = max_light*pulse_multiplier
		grow_tween.connect("finished", on_grow_tween_finished)
		
		for body in $Area3D.get_overlapping_bodies():
			print(body)
	charging_pulse = false
	$Pulse.value = 0

func _on_toggle_outline_area_body_entered(body):
	if body.is_in_group("has_outline"):
		body.show_outline()


func _on_toggle_outline_area_body_exited(body):
	if body.is_in_group("has_outline"):
		body.hide_outline()


func on_grow_tween_finished():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	var percent = ($Energy.value/$Energy.max_value)
	tween.tween_property($MeshInstance3D/OmniLight3D, 'light_energy',  clamp(max_light*percent, min_light, max_light), 0.9)
	tween.connect("finished", on_tween_finished)
	var tween_color = create_tween()
	tween_color.set_ease(Tween.EASE_OUT)
	tween_color.tween_property($MeshInstance3D/OmniLight3D, 'light_color',  Vector3(1,1,1), 0.9)

func on_tween_finished():
	can_update_light = true
	
