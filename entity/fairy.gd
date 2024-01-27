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

@onready var _can_move = true
@onready var _is_charging = false
@onready var max_y_offset: float = 1

var direction = Vector3(0,0,0)
var distance

# Called when the node enters the scene tree for the first time.
func _ready():
	$Energy.value = 100.0
	$MeshInstance3D/OmniLight3D.light_energy = max_light
	$ToggleOutlineArea/CollisionShape3D.shape.radius = toggle_outline_radius
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed('click') and not _is_charging:
		_can_move = not _can_move
	
	var energy_percent = ($Energy.value/$Energy.max_value)
	$MeshInstance3D.scale = Vector3(1,1,1)*clamp(max_size*energy_percent, min_size, max_size)
	$MeshInstance3D/OmniLight3D.light_energy = clamp(max_light*energy_percent, min_light, max_light)
	
	if _can_move:
		move(energy_percent)


func move(energy_percent: float) -> void:
	var mouse = Game.get_mouse() + Vector3(0,clamp(max_y_offset * energy_percent, 0, max_y_offset),0)
	distance = global_position.distance_to(mouse)
	if(distance > distance_min):
		direction += (mouse - global_position).normalized()*2
		direction = direction.normalized()
		var speed = clamp(distance, minSpeed, slowSpeed + (maxSpeed-slowSpeed) * energy_percent)
		velocity = direction*speed
		move_and_slide()
		add_charge(-speed)


func add_charge(multiplier: float = 1):
	$Energy.value += $Energy.step * multiplier * energy_expense_modifier


func _on_toggle_outline_area_body_entered(body):
	if body.is_in_group("has_outline"):
		body.show_outline()


func _on_toggle_outline_area_body_exited(body):
	if body.is_in_group("has_outline"):
		body.hide_outline()


func _on_toggle_outline_area_area_entered(area):
	if area.is_in_group("has_outline"):
		area.show_outline()


func _on_toggle_outline_area_area_exited(area):
	if area.is_in_group("has_outline"):
		area.hide_outline()


func _on_charge_area_area_entered(area):
	if area.is_in_group("charge_station"):
		max_y_offset = 0.2
		for _i in range(10):
			move(1)
		_is_charging = true
		_can_move = false


func liberate() -> void:
	if _is_charging:
		_is_charging = false
		_can_move = true
		max_y_offset = 1
