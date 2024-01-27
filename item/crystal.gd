extends Node3D

var active = false

const max_light = 8
const min_light = 0.5
const energy_step = 0.01
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#active = global_position.distance_to(Game.get_fairy()) <= fairy_distance:
	$Area3D/MeshInstance3D/Outline.visible = active
	if active:
		$Area3D/MeshInstance3D.get_surface_override_material(0).emission_energy_multiplier = 6
		add_charge(6)
	else: 
		$Area3D/MeshInstance3D.get_surface_override_material(0).emission_energy_multiplier = 2
		add_charge(-1)
	pass

func add_charge(multiplier:float=1):
	$Area3D/OmniLight3D.light_energy = clamp($Area3D/OmniLight3D.light_energy+energy_step*multiplier, min_light, max_light)

func _on_area_3d_body_entered(body):
	if body == Game.get_fairy():
		active = true
	pass # Replace with function body.

func _on_area_3d_body_exited(body):
	if body == Game.get_fairy():
		active = false
	pass # Replace with function body.
