extends CharacterBody2D

class_name EnemyBase

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var health_component: Node = $HealthComponent
@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D

@export_group("Estadísticas")
@export var movement_speed: float = 60.0
@export var max_speed: float = 100.0
@export var attack_range: float = 30.0

@export_group("Comportamiento")
@export var aggro_range: float = 300.0
@export var damage: int = 1

func _ready():
	if health_component:
		health_component.health_depleted.connect(_on_death)

	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0

	await get_tree().physics_frame

	if state_machine:
		state_machine.init(self)

func _physics_process(_delta: float) -> void:
	move_and_slide()

	
func _on_death() -> void:
	queue_free()
