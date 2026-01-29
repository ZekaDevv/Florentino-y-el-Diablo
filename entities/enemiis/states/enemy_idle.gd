extends State

class_name EnemyIdle

func enter() -> void:
	print("Enemigo: Entrando en estado Idle")
	
	enemy.velocity = Vector2.ZERO

func update(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass 
