extends HBoxContainer

@onready var slots = get_children()

func _ready() -> void:
	GameManager.inventory_updated.connect(_on_inventory_updated)
	GameManager.active_slot_changed.connect(_on_active_slot_changed)

	_initialize_inventory()

func _initialize_inventory():
	for i in range(GameManager.inventory.size()):
		_on_inventory_updated(i, GameManager.inventory[i])
	
	_on_active_slot_changed(GameManager.active_slot_index)

func _on_inventory_updated(index: int, item: WeaponData):
	if index < slots.size():
		slots[index].update_icon(item)

func _on_active_slot_changed(index: int):
	for i in range(slots.size()):
		if i == index:
			slots[i].set_selected(true)
		else:
			slots[i].set_selected(false) 
