extends CharacterBody3D

@export_category("Area of Detection Radiuses")
@export var toggle_outline_radius: float = 3.5
@export var charge_radius: float = 3.5
@export_category("Fairy Movement")
@export var maxSpeed: float = 15
@export var slowSpeed: float = 5
@export var minSpeed: float = 1
@export var distance_min: float = 0.1
@export var min_size: float = 0.18
@export var max_size: float = 0.25
@export_category("Fairy Luminescense")
@export var max_light: float = 5.0
@export var min_light: float = 0.5
@export var energy_expense_modifier: float = 1.5

@export_category("Fairy Luminescense")
@export var control_flight: bool = true
@export var max_y_offset: float = 20
@export var min_y_offset: float = 1
@export var y_offset_step: float = 0.5
var y_offset: float = min_y_offset

@onready var _can_move = true
@onready var _is_charging = false

var direction = Vector3(0,0,0)
var distance

var move_target = null

const pulse_light_multiplier = 2
const min_pulse_charge = 50
var charging_pulse = false
var can_update_light = true

func _ready():
	$Energy.value = 100.0
	$MeshInstance3D/OmniLight3D.light_energy = max_light
	$ToggleOutlineArea/CollisionShape3D.shape.radius = toggle_outline_radius


func _process(_delta):
	if Input.is_action_just_released('l_click') and not _is_charging:
		if move_target:
			move_target = null
		else:
			for area in $ToggleOutlineArea.get_overlapping_bodies()+ $ToggleOutlineArea.get_overlapping_areas():
				if not move_target:
					if area.is_in_group("has_outline"):
						if area.is_in_group("charge_station"):
							_is_charging = true
						max_y_offset = 0.2
						move_target = area
			if move_target == null:
				_can_move = not _can_move
	if Input.is_action_pressed('r_click'):
		charging_pulse = true
	if Input.is_action_just_released('r_click'):
		pulse()

	if Input.is_action_pressed('fairy_down'):
		y_offset = clamp(y_offset-y_offset_step, min_y_offset, max_y_offset)
	if Input.is_action_pressed('fairy_up'):
		y_offset = clamp(y_offset+y_offset_step, min_y_offset, max_y_offset)

	var energy_percent = ($Energy.value/$Energy.max_value)
	$MeshInstance3D.scale = Vector3(1,1,1)*clamp(max_size*energy_percent, min_size, max_size)
		
	if can_update_light:
		if charging_pulse:
			var pulse_percent = 1 - $Pulse.value/$Pulse.max_value
			$MeshInstance3D/OmniLight3D.light_color = Color(1, pulse_percent, pulse_percent)
			$Pulse.value += $Pulse.step
			$MeshInstance3D/OmniLight3D.light_energy = clamp(max_light*pulse_percent, min_light, max_light)
		else:
			$MeshInstance3D/OmniLight3D.light_color = Color(1, 1, 1)
			$MeshInstance3D/OmniLight3D.light_energy = clamp(max_light*energy_percent, min_light, max_light)
	
	if _can_move:
		move(energy_percent)

func move(energy_percent: float) -> void:
	var target = (move_target.global_position if move_target else Game.get_mouse()) + Vector3(0,clamp(y_offset * energy_percent, min_y_offset, max_y_offset),0)
	distance = global_position.distance_to(target)
	if(distance > distance_min):
		direction += (target - global_position).normalized()*2
		direction = direction.normalized()
		var speed = clamp(distance, minSpeed, slowSpeed + (maxSpeed-slowSpeed) * energy_percent)
		velocity = direction*speed
		move_and_slide()
		add_charge(-speed)


func add_charge(multiplier: float = 1):
	$Energy.value += $Energy.step * multiplier * energy_expense_modifier


func pulse():
	if($Pulse.value >= min_pulse_charge):
		can_update_light = false
		var pulse_multiplier = $Pulse.value/min_pulse_charge
		var pulse_percent = $Pulse.value/$Pulse.max_value
		$PulseArea/CollisionShape3D.scale = Vector3(1,1,1)*pulse_multiplier
		var grow_tween = create_tween()
		#grow_tween.set_ease(Tween.EASE_OUT)
		grow_tween.set_trans(Tween.TRANS_ELASTIC)
		grow_tween.tween_property($MeshInstance3D/OmniLight3D, 'light_energy',  max_light*pulse_light_multiplier*pulse_percent, 0.1)
		#$MeshInstance3D/OmniLight3D.light_energy = max_light*pulse_multiplier
		grow_tween.connect("finished", on_grow_tween_finished)
		
		#for body in $PulseArea.get_overlapping_bodies():
			#print(body)
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
	

func _on_toggle_outline_area_area_entered(area):
	if area.is_in_group("has_outline"):
		area.show_outline()


func _on_toggle_outline_area_area_exited(area):
	if area.is_in_group("has_outline"):
		area.hide_outline()


func liberate() -> void:
	if _is_charging:
		_is_charging = false
		_can_move = true
		max_y_offset = 1
		move_target = null
