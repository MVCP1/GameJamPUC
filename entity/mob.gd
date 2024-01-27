extends CharacterBody3D

@export var movement_speed: float = 2.0
@export var acceleration: float = 10.0
@export var rotation_speed: float = 12.0

@export var light_detection_threshold: float = 0.3

@onready var _gravity: float = -ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var active: bool = false
@onready var light_detection := $SubViewport/LightDetection
@onready var sub_viewport := $SubViewport
@onready var texture_rect := $CanvasLayer/TextureRect

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	active = true

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)


func get_average_color(texture: ViewportTexture) -> Color:
	var image = texture.get_image()
	image.resize(1,1,Image.INTERPOLATE_LANCZOS)
	return image.get_pixel(0,0)


func _physics_process(delta):
	$LightSensorScene.refresh()
	var light_value = $LightSensorScene.light_level
	
	if light_value < light_detection_threshold:
		active = true
	else:
		active = false
	
	if not active:
		return
	
	set_movement_target(Game.get_player().global_position)

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	var direction = current_agent_position.direction_to(next_path_position)
	_orient_to_direction(direction, delta)
	
	velocity = velocity.lerp(direction * movement_speed, acceleration * delta)
	velocity.y += _gravity * delta
	move_and_slide()


func _orient_to_direction(direction: Vector3, delta: float) -> void:
	if direction == Vector3.ZERO:
		return
	var left_axis := Vector3.UP.cross(direction)
	var rotation_basis := Basis(left_axis, Vector3.UP, direction).get_rotation_quaternion()
	transform.basis = Basis(transform.basis.get_rotation_quaternion().slerp(rotation_basis, delta * rotation_speed))
