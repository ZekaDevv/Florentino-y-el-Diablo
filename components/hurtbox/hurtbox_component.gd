extends Area2D
class_name Hurtbox

@onready var health_component = get_parent().get_node("HealthComponent")

func take_damage(quantity: int) -> void:
	print("🛡️ DEBUG: Hurtbox recibió llamada de daño.")
	if health_component:
		print("❤️ DEBUG: HealthComponent encontrado. Restando ", quantity, " de vida.")
		health_component.take_damage(quantity)
	else:
		print("💀 DEBUG: ¡ERROR CRÍTICO! HealthComponent es NULL. Revisa la ruta o el nombre del nodo.")
