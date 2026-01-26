extends Area2D
class_name Hurtbox

@onready var health_component = get_parent().get_node("HealthComponent")

func be_damage(quantity: int) -> void:
	if health_component:
		health_component.take_damage(quantity)
