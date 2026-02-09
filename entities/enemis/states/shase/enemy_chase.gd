extends State

class_name EnemyChase

var path_timer: float = 0.0
var range_exit: float = 1.5

func enter() -> void:
	enemy.sprite.play("walk_lateral")

func _physics_process(delta):
	if not enemy.player:
		return
	
	var distance = enemy.global_position.distance_to(enemy.player.global_position)
	
	if distance < enemy.attack_range:
		#state_machine.change_state(state_machine.states["attack"])
		return
	
	if distance > enemy.detection_range * range_exit:
		state_machine.change_state(state_machine.states["EnemyIdle".to_lower()])
		return
	
	path_timer -= delta
	if path_timer <= 0:
		enemy.nav_agent.target_position = enemy.player.global_position
		path_timer = 0.2
	
	var next_path_pos = enemy.nav_agent.get_next_path_position()
	var current_pos = enemy.global_position

	var direction = current_pos.direction_to(next_path_pos)
	enemy.velocity = enemy.velocity.lerp(direction * enemy.move_speed, enemy.acceleration * delta)

	if direction.x != 0:
		enemy.sprite.flip_h = direction.x < 0
	

	
