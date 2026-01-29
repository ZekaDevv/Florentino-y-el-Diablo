extends Area2D
class_name BaseBullet

@export_group("Estadísticas")
@export var damage: float = 1
@export var speed: int = 300
@export var life_time: float = 1

@onready var hitbox = $HitboxComponentBullet

var direction: Vector2 = Vector2.RIGHT
var player_inertia: Vector2 = Vector2.ZERO

func _ready():
	if hitbox:
		hitbox.damage = damage
	
	get_tree().create_timer(life_time).timeout.connect(queue_free)


func _process(delta: float) -> void:
	position += ((direction * speed) + player_inertia) *  delta
