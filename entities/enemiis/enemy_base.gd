extends CharacterBody2D

class_name EnemyBase

@onready var health_component: Node = $HealthComponent
@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D

@export var movement_speed: float = 100.0

func _ready():
	if health_component:
		health_component.health_depleted.connect(_on_death)

	if state_machine:
		state_machine.init(self)

func _physics_process(_delta: float) -> void:
	move_and_slide()

	
func _on_death() -> void:
	queue_free()
