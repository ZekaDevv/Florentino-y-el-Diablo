extends Node

class_name InventoryComponent

@onready var weapon_holder = $"../Weapon"

var can_switch_weapon: bool = true

const SWITCH_COOLDOWN: float = 0.5

func _ready():
	GameManager.active_slot_changed.connect(_on_active_slot_changed)
	GameManager.inventory_updated.connect(_on_inventory_updated)

	_update_weapon_visuals(GameManager.active_slot_index)

func _unhandled_input(event) -> void:
	if not can_switch_weapon:
		return
	
	if event.is_action_pressed("weapon_next"):
		switch_to_next_weapon()
		return
				
	if event.is_action_pressed("weapon_prev"):
		switch_to_prev_weapon()
		return
	
	if event is InputEventKey and event.is_pressed():
		
		match event.keycode:
			KEY_1: _attempt_switch_weapon(0)
			KEY_2: _attempt_switch_weapon(1)
			KEY_3: _attempt_switch_weapon(2)
			KEY_4: _attempt_switch_weapon(3)  
			KEY_5: _attempt_switch_weapon(4)
			KEY_6: _attempt_switch_weapon(5)
	
			
func _on_active_slot_changed(new_index: int):
	_update_weapon_visuals(new_index)

func _on_inventory_updated(slot_index: int, _item: Resource):
	if slot_index == GameManager.active_slot_index:
		_update_weapon_visuals(slot_index)

func _update_weapon_visuals(index: int) -> void:
	for child in weapon_holder.get_children():
		child.queue_free()
	
	var item_data = GameManager.inventory[index]
	
	if item_data.weapon_scene:
		var new_weapon_instance = item_data.weapon_scene.instantiate()
		weapon_holder.add_child(new_weapon_instance)


func _attempt_switch_weapon(index: int):
		if index == GameManager.active_slot_index:
				return

		can_switch_weapon = false
		
		GameManager.change_active_slot(index)
		
		await get_tree().create_timer(SWITCH_COOLDOWN).timeout
		
		can_switch_weapon = true


func switch_to_next_weapon():
	var current = GameManager.active_slot_index
	var next_index = (current + 1) % 6 
		
	_attempt_switch_weapon(next_index)

func switch_to_prev_weapon():
	var current = GameManager.active_slot_index
	var prev_index = (current - 1 + 6) % 6
		
	_attempt_switch_weapon(prev_index)
