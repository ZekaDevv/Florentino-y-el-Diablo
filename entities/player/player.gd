extends CharacterBody2D

@onready var health_component = $HealthComponent
@onready var weapon_holder = $Weapon 
@onready var sprite_animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D

var zoom_normal: Vector2 = Vector2(2.25, 2.25)
var zoom_dialogo: Vector2 = Vector2(3.5, 3.5)
var tiempo_zoom: float = 1

var _max_speed : float = 150.00
var _acceleration: float = 1000.00
var _friction: float = 800.00 

var _remember_shot_direction: bool = false

var _current_weapon: Weapon

var deadzone: float = 0.99

func _ready():
	GameManager.is_dialog_active = false
	add_to_group("player")
	GameManager.player_died.connect(_on_death)

	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

	health_component.health_changed.connect(flash_red)

func _physics_process(delta: float) -> void:
	if GameManager.is_dialog_active:
		sprite_animation.play("idle")
		velocity = Vector2.ZERO
		return

		
	if weapon_holder.get_child_count() > 0:
		var child = weapon_holder.get_child(0)
		_current_weapon = child

	var _direction: Vector2 = Input.get_vector(
		"left_movement", "right_movement", "up_movement", "down_movement", deadzone
		)
		
	var _shot_vector = Input.get_vector(
		"left_shot", "right_shot", "up_shot", "down_shot", deadzone
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
	sprite_animation.play("death")



func _on_dialogue_started(_resource):
		_smooth_zoom(zoom_dialogo)

func _on_dialogue_ended(_resource):
		_smooth_zoom(zoom_normal)

func _smooth_zoom(target_zoom: Vector2):
		var tween = create_tween()
		tween.tween_property(camera, "zoom", target_zoom, tiempo_zoom)\
				.set_trans(Tween.TRANS_QUART)\
				.set_ease(Tween.EASE_OUT)

func flash_red(_amount):
		var tween = create_tween()
		tween.tween_property(sprite_animation, "modulate", Color(1, 0, 0), 0.1)
		tween.tween_property(sprite_animation, "modulate", Color(1, 1, 1), 0.5)
