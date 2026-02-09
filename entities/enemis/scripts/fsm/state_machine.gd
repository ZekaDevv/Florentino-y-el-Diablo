extends Node

class_name StateMachine

@export var initial_state: State

var current_state: State

var states: Dictionary = {}

func init(enemy: EnemyBase) -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			
			child.state_machine = self
			child.enemy = enemy

	if initial_state:
		change_state(initial_state)
		

func _process(delta) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func change_state(new_state: State) -> void:
	if new_state is State:
		if current_state:
			current_state.exit()

		current_state = new_state
		current_state.enter()
