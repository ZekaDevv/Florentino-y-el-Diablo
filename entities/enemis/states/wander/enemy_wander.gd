extends State
class_name EnemyWander

@export var wander_radius: float = 100.0
@export var wander_speed: float = 40.0

var start_position: Vector2

func enter() -> void:
	start_position = enemy.global_position
	var _random_target = _get_random_point()
	enemy.nav_agent.target_position = _random_target
	
func physics_update(_delta: float) -> void:
	if enemy.nav_agent.is_navigation_finished():
		state_machine.change_state(state_machine.states["enemyidle"])
		return

	var current_pos = enemy.global_position
	var next_path_pos = enemy.nav_agent.get_next_path_position()

	var direction = current_pos.direction_to(next_path_pos)
	
	enemy.velocity = direction * wander_speed

func _get_random_point() -> Vector2:
	var random_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	return start_position + (random_dir * wander_radius)
