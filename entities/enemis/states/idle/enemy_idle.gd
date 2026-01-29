extends State

class_name EnemyIdle

@export var min_wait_time: float = 1.0
@export var max_wait_time: float = 3.0

var wait_timer: float

func enter() -> void:
	enemy.velocity = Vector2.ZERO
	wait_timer = randf_range(min_wait_time, max_wait_time)
	

func update(delta: float) -> void:
	wait_timer -= delta

	if wait_timer <= 0:
		state_machine.change_state(state_machine.states["enemywander"]) 

func _physics_process(_delta: float) -> void:
	pass 
