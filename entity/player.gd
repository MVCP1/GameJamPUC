extends CharacterBody3D

@export_category("Groud Movement")
@export var move_speed: float = 4.5
@export var acceleration := 3.0
@export var rotation_speed := 9.0
@export var stopping_speed := 2.0
@export var moving_objects_speed_modifier: float = 0.7
@export var movement_on_air_penalizer: float = 0.96
@export_category("Air movement")
@export var jump_initial_impulse := 12.0

#@onready var _is_on_floor_buffer: bool = false
@onready var _gravity: float = -ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var _move_direction := Vector3.ZERO
@onready var _interact_detector := $InteractDetector
@onready var _is_grabbing: bool = false
@onready var _save_fairy_area := $SaveFairyArea

func _physics_process(delta: float) -> void:
	var is_just_jumping: bool = Input.is_action_just_pressed("space") and is_on_floor()
	var just_stopped_jump: bool = Input.is_action_just_released("space") and velocity.y > 0 and not is_on_floor()
	var is_trying_to_interact: bool = Input.is_action_pressed("interact")

	_move_direction = _get_input_direction()
	if not _is_grabbing:
		_orient_to_direction(_move_direction, delta)
	else:
		_is_grabbing = false
	
	var y_velocity: float = velocity.y
	velocity.y = 0.0
	
	velocity = velocity.lerp(_move_direction * move_speed, acceleration * delta)
	if _move_direction.length() == 0 and velocity.length() < stopping_speed:
		velocity = Vector3.ZERO
	
	if not is_on_floor():
		velocity *= movement_on_air_penalizer
	
	velocity.y = y_velocity
	if velocity.y < 0:
		velocity.y += _gravity * 1.65 * delta
	else:
		velocity.y += _gravity * delta
	
	if is_just_jumping:
		velocity.y += jump_initial_impulse
	if just_stopped_jump:
		velocity.y /= 2
	
	if is_trying_to_interact:
		_try_to_interact(Vector3(velocity.x, 0, velocity.z) * moving_objects_speed_modifier)

	if _is_grabbing:
		velocity = velocity * moving_objects_speed_modifier
	move_and_slide()


func _get_input_direction() -> Vector3:
	var raw_input := -Input.get_vector("left", "right", "up", "down").rotated(-PI/4)

	var input := Vector3.ZERO
	# This is to ensure that diagonal input isn't stronger than axis aligned input
	input.x = -raw_input.x * sqrt(1.0 - raw_input.y * raw_input.y / 2.0)
	input.z = -raw_input.y * sqrt(1.0 - raw_input.x * raw_input.x / 2.0)

	input.y = 0.0
	return input


func _orient_to_direction(direction: Vector3, delta: float) -> void:
	if direction == Vector3.ZERO:
		return
	var left_axis := Vector3.UP.cross(direction)
	var rotation_basis := Basis(left_axis, -Vector3.UP, direction).get_rotation_quaternion()
	transform.basis = Basis(transform.basis.get_rotation_quaternion().slerp(rotation_basis, delta * rotation_speed))


func _try_to_interact(vel_move: Vector3) -> void:
	# try freeing fairy
	if _save_fairy_area.has_overlapping_bodies():
		_save_fairy_area.get_overlapping_bodies()[0].liberate()
	
	if not _interact_detector.has_overlapping_bodies():
		return
	
	var bodies: Array[Node3D] = _interact_detector.get_overlapping_bodies()
	
	# try grabbing
	for body in bodies:
		if body.is_in_group("movable"):
			body.velocity = vel_move
			body.move_and_slide()
			_is_grabbing = true
