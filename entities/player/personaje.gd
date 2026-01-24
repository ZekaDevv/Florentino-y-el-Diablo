extends CharacterBody2D

@export var scene_bullet: PackedScene
@export_range(0.0, 1.0) var inertia_factor: float = 0.5
@onready var shot_point: Marker2D = $Marker2D
@onready var sprite_animation : AnimatedSprite2D = $AnimatedSprite2D

var _max_speed : float = 200.00
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
		#velocity = _max_speed * _direction
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, _friction * delta)
		#velocity = Vector2.ZERO

	move_and_slide()
	
	_animation_player(_shot_vector)
	
	if _shot_vector != Vector2.ZERO and can_shot:
		var _vector_final = _shot_vector 
		
		if _shot_vector != Vector2.ZERO:
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



func _shot(dir_bullet: Vector2) -> void:
	var _new_bullet = scene_bullet.instantiate()

	_new_bullet.player_inertia = velocity * inertia_factor	
	var _parallel_speed = velocity.project(dir_bullet)
	var _lateral_velocity = velocity - _parallel_speed
	
	_new_bullet.player_inertia = _lateral_velocity * inertia_factor

	get_parent().add_child(_new_bullet)
	
	if shot_point:
		_new_bullet.global_position = shot_point.global_position
	else:
		_new_bullet.global_position = global_position 

	_new_bullet.direction = dir_bullet

	can_shot = false
	
	get_tree().create_timer(_cooldown).timeout.connect(_shot_reset)
	
	
	
func _shot_reset() -> void:
	can_shot = true
