extends Node

class_name InventoryComponent

@onready var weapon_holder = $"../Weapon"

func _ready():
	GameManager.active_slot_changed.connect(_on_active_slot_changed)
	GameManager.inventory_updated.connect(_on_inventory_updated)

	_update_weapon_visuals(GameManager.active_slot_index)

func _unhandled_input(event) -> void:
	if event is InputEventKey and event.is_pressed():
		
		match event.keycode:
			KEY_1: GameManager.change_active_slot(0)
			KEY_2: GameManager.change_active_slot(1)
			KEY_3: GameManager.change_active_slot(2)
			KEY_4: GameManager.change_active_slot(3)
			KEY_5: GameManager.change_active_slot(4)
			KEY_6: GameManager.change_active_slot(5)
			
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
