extends Area2D
class_name BaseBullet

@export_group("Estadísticas")
@export var damage: float = 1
@export var speed: int = 300
@export var life_time: float = 1

@onready var sprite_animation = $AnimatedSprite2D
@onready var hitbox = $HitboxComponentBullet

var direction: Vector2 = Vector2.RIGHT
var player_inertia: Vector2 = Vector2.ZERO
var is_exploding: bool = false

func _ready():
	sprite_animation.play("idle")
	
	if hitbox:
		hitbox.damage = damage
		
	sprite_animation.animation_finished.connect(_on_animation_finished)

	get_tree().create_timer(life_time).timeout.connect(explode)

func _process(delta: float) -> void:
	if is_exploding:
		return
		
	position += ((direction * speed) + player_inertia) * delta

func explode():
	if is_exploding: return
	
	is_exploding = true
	speed = 0

	if hitbox:
		hitbox.set_deferred("monitorable", false)
		hitbox.set_deferred("monitoring", false)
	
	sprite_animation.play("explodes")

func _on_animation_finished():
	if sprite_animation.animation == "explodes":
		queue_free()
