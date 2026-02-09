extends State

class_name EnemyIdle

func enter() -> void:
	enemy.velocity = Vector2.ZERO
	enemy.sprite.play("idle")

func physics_update(_delta: float) -> void:
	if not enemy.player:
		return
	
	var distance = enemy.global_position.distance_to(enemy.player.global_position) 
	
	if distance < enemy.detection_range:
		print("lo detectoooo")
