extends CharacterBody2D

@onready var health_component = $HealthComponent
@onready var weapon_holder = $Weapon 
@onready var sprite_animation : AnimatedSprite2D = $AnimatedSprite2D

var _max_speed : float = 150.00
var _acceleration: float = 1000.00
var _friction: float = 800.00 

var _remember_shot_direction: bool = false

var _current_weapon: Weapon

func _ready():
	health_component.health_depleted.connect(_on_death)

func _physics_process(delta: float) -> void:
	if weapon_holder.get_child_count() > 0:
		var child = weapon_holder.get_child(0)
		_current_weapon = child

	var _direction: Vector2 = Input.get_vector(
		"left_movement", "right_movement", "up_movement", "down_movement"
		)
		
	var _shot_vector = Input.get_vector(
		"left_shot", "right_shot", "up_shot", "down_shot"
		)

	if _direction != Vector2.ZERO:
		velocity = velocity.move_toward(_direction * _max_speed, _acceleration * delta)
		#velocity = _max_speed * _direction
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, _friction * delta)
		#velocity = Vector2.ZERO

	move_and_slide()
	
	_animation_player(_shot_vector)

	if _shot_vector != Vector2.ZERO and _current_weapon:
		_current_weapon.shoot(_shot_vector, velocity)
	
	

func _animation_player(shot_input: Vector2) -> void:

	if shot_input.x != 0:
		_remember_shot_direction = shot_input.x < 0 
		sprite_animation.flip_h = _remember_shot_direction

	elif velocity.x != 0:
		_remember_shot_direction = velocity.x < 0
		sprite_animation.flip_h = _remember_shot_direction


	if velocity.length() > 0:
		sprite_animation.play("walk")
	else:
		sprite_animation.play("idle")


func _on_death() -> void:
	set_physics_process(false)
	sprite_animation.play("idle")
