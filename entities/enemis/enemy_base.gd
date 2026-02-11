extends CharacterBody2D

class_name EnemyBase

@onready var state_machine: StateMachine = $StateMachine
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D 
@onready var health_component: Node = $HealthComponent 
@onready var hurtbox_component: Node = $HurtboxComponent
@onready var weapon_holder: Node2D = $Weapon

@export_group("Estadísticas de Movimiento")
@export var move_speed: float = 60.0
@export var acceleration: float = 10.0

@export_group("IA y Combate")
@export var detection_range: float = 150.0
@export var attack_range: float = 25.0
@export var attack_cooldown: float = 1.0

var current_weapon: Weapon
var player: CharacterBody2D = null

func _ready():
	if health_component:
		health_component.health_depleted.connect(_on_death)
	
	player = get_tree().get_first_node_in_group("player")

	if GameManager.has_signal("player_died"):
		GameManager.player_died.connect(_on_player_died)
	
	nav_agent.path_desired_distance = 10.0
	nav_agent.target_desired_distance = 10.0

	state_machine.init(self)

	if weapon_holder.get_child_count() > 0:
				var child = weapon_holder.get_child(0)
				if child is Weapon:
						current_weapon = child
	
	health_component.health_changed.connect(flash_red)

func _physics_process(_delta):
	move_and_slide()
	_update_animation_direction()

func _update_animation_direction() -> void:
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				sprite.play("walk_lateral")
				sprite.flip_h = false
			else:
				sprite.play("walk_lateral")
				sprite.flip_h = true 
		else:
			if velocity.y > 0:
				sprite.play("walk_front")
			else:
				sprite.play("walk_back")
	else:
		sprite.play("idle")


func _on_death() -> void:
	queue_free()

func _on_player_died():
	player = null

func flash_red():
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 0, 0), 0.1)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.5)
