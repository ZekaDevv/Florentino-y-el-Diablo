extends CharacterBody2D

class_name EnemyBase

@onready var state_machine: StateMachine = $StateMachine
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D 
@onready var health_component: Node = $HealthComponent 
@onready var hurtbox_component: Node = $HurtboxComponent

@export_group("Estadísticas de Movimiento")
@export var move_speed: float = 60.0
@export var acceleration: float = 10.0

@export_group("IA y Combate")
@export var detection_range: float = 150.0
@export var attack_range: float = 25.0
@export var attack_cooldown: float = 1.0

var player: CharacterBody2D = null

func _ready():
	if health_component:
		health_component.health_depleted.connect(_on_death)
	
	player = get_tree().get_first_node_in_group("player")
	
	nav_agent.path_desired_distance = 10.0
	nav_agent.target_desired_distance = 10.0

	state_machine.init(self)
	
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
