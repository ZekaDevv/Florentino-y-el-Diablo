extends Area2D

class_name Hitbox

@export var damage: float = 1

func _on_area_entered(area):

	if area is Hurtbox:
		area.take_damage(damage)
