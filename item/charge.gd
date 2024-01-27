extends Node3D

var active
const charge = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#active = global_position.distance_to(Game.get_fairy()) <= fairy_distance:
	if active:
		$Area3D/MeshInstance3D.get_surface_override_material(0).emission_energy_multiplier = 5
		Game.get_fairy().add_charge(charge)
	else:
		$Area3D/MeshInstance3D.get_surface_override_material(0).emission_energy_multiplier = 1
	pass


func _on_area_3d_body_entered(body):
	if body == Game.get_fairy():
		active = true
	pass # Replace with function body.

func _on_area_3d_body_exited(body):
	if body == Game.get_fairy():
		active = false
	pass # Replace with function body.
