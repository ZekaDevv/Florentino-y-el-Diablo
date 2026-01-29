extends Area2D

var damage: int = 1

func _on_area_entered(area: Area2D) -> void:
	area.take_damage(damage)
