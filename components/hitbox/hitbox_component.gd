extends Area2D

class_name Hitbox

@export var damage: int = 1

func _on_area_entered(area):
	print("🔍 DEBUG: La bala tocó el área: ", area.name)

	if area is Hurtbox:
		print("✅ DEBUG: ¡Es una Hurtbox válida! Enviando daño...")
		area.take_damage(damage)
	else:
		print("❌ DEBUG: No es una Hurtbox. El script del área es: ", area.get_script())
