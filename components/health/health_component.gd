extends Node

@export var is_player: bool = false
@export var max_health: int = 20
var current_health: int

var _local_health: float

signal health_changed(current: int)
signal health_depleted

func _ready() -> void:
	if is_player:
		GameManager.max_health = max_health
		GameManager.current_health = max_health
		GameManager.health_changed.emit(GameManager.current_health)
	else:
		_local_health = max_health

func take_damage(amount: float):
	if is_player:
		GameManager.take_damage(amount)
		health_changed.emit(GameManager.current_health)
		
		if GameManager.current_health <= 0:
			health_depleted.emit()
			
	else:
		_local_health -= amount
		
		if _local_health <= 0:
			_local_health = 0
			health_depleted.emit()
		
		health_changed.emit(_local_health)



		
