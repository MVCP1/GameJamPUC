extends AnimatableBody3D

func show_outline() -> void:
	$CollisionShape3D/Outline.visible = true


func hide_outline() -> void:
	$CollisionShape3D/Outline.visible = false
