extends Camera3D

const upVector = Vector3(1,sqrt(2),1)*10

var mouseMaxDistance: float = 2.5
var centerAreaPosition: Vector3

var shake: float = 0
var shakeSlowRate: float = 10

enum shakeTypeList {
	SHOOTS,
	FALLS,
	DAMAGE
}

# Called when the node enters the scene tree for the first time.
func _ready():
	centerAreaPosition = Game.get_player().position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	setCameraPosition()
	$centerArea.global_position = centerAreaPosition
	$PlayerCenterDist/Value.text = str(Game.get_player().position.distance_to(centerAreaPosition))
	if Input.is_action_just_pressed('click'):
		shakeScreen(shakeTypeList.SHOOTS)
	if shake > 0:
		handleShake(delta)
	pass

func getMousePosition():# Get the mouse position in screen coordinates
	var mouse_pos_screen = get_viewport().get_mouse_position()
	# Project the mouse position onto the 3D world
	var ray_origin = project_ray_origin(mouse_pos_screen)
	var ray_direction = project_ray_normal(mouse_pos_screen)
	# Calculate the intersection point with the plane at y = 0 (assuming a flat ground)
	var intersection_point = Plane(Vector3(0, 1, 0), Game.get_player().position.y).intersects_ray(ray_origin, ray_direction)
	return intersection_point if intersection_point else Vector3(0,0,0)


func setCameraPosition():
	#if (Game.get_player().position.distance_to(centerAreaPosition) > playerAreaDistance):
	
	var playerToTarget : Vector3 = (getMousePosition() if Game.get_fairy().can_move else Game.get_fairy().global_position ) - Game.get_player().position
	centerAreaPosition = Game.get_player().position + (playerToTarget.normalized() * min(mouseMaxDistance, playerToTarget.length()/2)) 
	#centerAreaPosition = Game.get_player().position.move_toward(get_mouse_position(), mouseMaxDistance)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, 'position', centerAreaPosition + upVector, 3)

func shakeScreen(shakeType : shakeTypeList) -> void:
	var strengh = 0
	var slowRate = 0
	match shakeType:
		shakeTypeList.SHOOTS:
			strengh = 1
			slowRate = 10
		shakeTypeList.FALLS:
			strengh = 1
			slowRate = 8
		shakeTypeList.DAMAGE:
			strengh = 3
			slowRate = 5
	if (shake > strengh*0.1): pass
	shake = strengh*0.1
	shakeSlowRate = slowRate
	
func handleShake(delta):
	shake = lerpf(shake, 0, shakeSlowRate*delta)
	h_offset = randf_range(-shake, shake)
	v_offset = randf_range(-shake, shake)*0.2
