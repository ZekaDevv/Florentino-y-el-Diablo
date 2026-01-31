extends Node

class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary

func init(enemy: CharacterBody2D) -> void:
	
	for child in get_children():
		if child is State:
			child.enemy = enemy
			child.state_machine = self
			states[child.name.to_lower()] = child

		if initial_state:
			change_state(initial_state)


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
