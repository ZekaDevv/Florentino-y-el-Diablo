extends State
class_name EnemyAttack

var shoot_interval: float = 0.5 
var timer: float = 0.0
var range_exit: float = 1.2

func enter() -> void:
	enemy.velocity = Vector2.ZERO
	shoot_at_player()
	timer = shoot_interval

func physics_update(delta: float) -> void:
	if not enemy.player:
		state_machine.change_state(state_machine.states["EnemyIdle".to_lower()])
		return
		
	timer -= delta
	
	if timer <= 0:
		shoot_at_player()
		timer = shoot_interval
	
	var distance = enemy.global_position.distance_to(enemy.player.global_position)
	
	if distance > enemy.attack_range * range_exit:
		state_machine.change_state(state_machine.states["EnemyChase".to_lower()])
		return

	var direction_to_player = enemy.global_position.direction_to(enemy.player.global_position)
	if direction_to_player.x != 0:
		enemy.sprite.flip_h = direction_to_player.x < 0

func shoot_at_player() -> void:
	if not enemy.current_weapon:
		return
		
	var direction = enemy.global_position.direction_to(enemy.player.global_position)
	
	enemy.current_weapon.shoot(direction, Vector2.ZERO) 
