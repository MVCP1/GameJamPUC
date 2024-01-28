extends Node3D

var active
const charge = 20

func _process(_delta):
	if active:
		$Area3D/MeshInstance3D.get_surface_override_material(0).emission_energy_multiplier = 5
		Game.get_fairy().add_charge(charge)
	else:
		$Area3D/MeshInstance3D.get_surface_override_material(0).emission_energy_multiplier = 1


func _on_area_3d_body_entered(body):
	if body == Game.get_fairy():
		active = true


func _on_area_3d_body_exited(body):
	if body == Game.get_fairy():
		active = false
