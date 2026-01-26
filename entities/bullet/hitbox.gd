extends CollisionShape2D

class_name Hitbox

@export var damage: int = 1

func _on_area_entered(area):
	if area is Hurtbox:
		area.be_damage(damage)
