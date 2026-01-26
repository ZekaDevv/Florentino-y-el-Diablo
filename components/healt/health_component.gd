extends Node

@export var max_health: int = 20
var current_health: int

signal health_changed(current: int)
signal health_depleted

func _ready() -> void:
	current_health = max_health
	health_changed.emit(current_health)

func take_damage(amount: int):
	current_health -= amount

	if current_health < 1:
		current_health = 0
		health_depleted.emit()
		return

	health_changed.emit(current_health) 



		
