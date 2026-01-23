extends CharacterBody2D

@export var scene_bullet: PackedScene
@onready var shot_point: Marker2D = $Marker2D

var _max_speed : float = 500.00
var _acceleration: float = 1800.00
var _friction: float = 1500.00 
var _remember_direction: bool = false

var _cooldown: float = 0.25
var can_shot: bool = true

@onready var sprite_animation : AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var _direction: Vector2 = Input.get_vector(
		"left_movement", "right_movement", "up_movement", "down_movement"
		)

	if _direction != Vector2.ZERO:
		velocity = velocity.move_toward(_direction * _max_speed, _acceleration * delta)
		#velocity = _direction * _max_speed
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, _friction * delta)
		#velocity = Vector2.ZERO
	move_and_slide()

	_animation_player()

	var _vector_raw = Input.get_vector(
		"left_shot", "right_shot", "up_shot", "down_shot"
		)

	if _vector_raw != Vector2.ZERO and can_shot:

		var _vector_final = _vector_raw 
		if abs(_vector_raw.x) > abs(_vector_raw.y):
			_vector_final = Vector2(sign(_vector_raw.x), 0)
		else:
			_vector_final = Vector2(0, sign(_vector_raw.y))
		
		_shot(_vector_final)

	

func _animation_player() -> void:

	
	if velocity.length() > 0:
		sprite_animation.play("walk")
		
		if velocity.x != 0:
			_remember_direction = velocity.x < 0
			sprite_animation.flip_h = _remember_direction
	else:
		sprite_animation.flip_h = _remember_direction
		sprite_animation.play("idle")



func _shot(dir: Vector2) -> void:
	var _new_bullet = scene_bullet.instantiate()

	get_parent().add_child(_new_bullet)
	
	if shot_point:
		_new_bullet.global_position = shot_point.global_position
	else:
		_new_bullet.global_position = global_position

	_new_bullet.direction = dir

	can_shot = false
	
	get_tree().create_timer(_cooldown).timeout.connect(_shot_reset)
	
func _shot_reset() -> void:
	can_shot = true
