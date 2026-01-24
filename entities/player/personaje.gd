extends CharacterBody2D

@export var scene_bullet: PackedScene
@onready var shot_point: Marker2D = $Marker2D
@onready var sprite_animation : AnimatedSprite2D = $AnimatedSprite2D

var _max_speed : float = 250.00
var _acceleration: float = 1000.00
var _friction: float = 800.00 

var _remember_shot_direction: bool = false

var _cooldown: float = 0.25
var can_shot: bool = true


func _physics_process(delta: float) -> void:
	var _direction: Vector2 = Input.get_vector(
		"left_movement", "right_movement", "up_movement", "down_movement"
		)
		
	var _shot_vector = Input.get_vector(
		"left_shot", "right_shot", "up_shot", "down_shot"
		)

	if _direction != Vector2.ZERO:
		velocity = velocity.move_toward(_direction * _max_speed, _acceleration * delta)
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, _friction * delta)

	move_and_slide()
	
	_animation_player(_shot_vector)
	
	if _shot_vector != Vector2.ZERO and can_shot:
		var _vector_final = _shot_vector 
		
		if abs(_shot_vector.x) > abs(_shot_vector.y):
			_vector_final = Vector2(sign(_shot_vector.x), 0)
			
		else: 
			_vector_final = Vector2(0, sign(_shot_vector.y))
		
		_shot(_vector_final)

	

func _animation_player(shot_input: Vector2) -> void:

	if shot_input.x != 0:
		_remember_shot_direction = shot_input .x < 0 
		sprite_animation.flip_h = _remember_shot_direction

	elif velocity.x != 0:
		_remember_shot_direction = velocity.x < 0
		sprite_animation.flip_h = _remember_shot_direction


	if velocity.length() > 0:
		sprite_animation.play("walk")
	else:
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
