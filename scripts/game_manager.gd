extends Node

signal health_changed(current: int)
signal player_died


var name_player: String = "Arturo"
var max_health: int
var current_health: int
var gold: int = 0

signal inventory_updated(slot_index: int, item: WeaponData)
signal active_slot_changed(new_index: int)

var inventory: Array[WeaponData] = [null, null, null, null, null, null]
var active_slot_index: int = 0


var music_volume: float = 1.0
var sfx_volume: float = 1.0


var is_dialog_active: bool = false;


func _ready():
	current_health = max_health

	var guitar = load("res://resources/weapon_data/weapon_guitar.tres") 
	var drun = load("res://resources/weapon_data/weapon_durn.tres") 
	var cuatro = load("res://resources/weapon_data/weapon_cuatro.tres") 
	var maracas = load("res://resources/weapon_data/weapon_maracas.tres") 
	var harp = load("res://resources/weapon_data/weapon_harp.tres") 
	var base = load("res://resources/weapon_data/weapon_null.tres") 
	
	add_item(base)
	add_item(maracas)
	add_item(drun)
	add_item(cuatro)
	add_item(guitar)
	add_item(harp)

func take_damage(amount: int):
	current_health -= amount

	if current_health <= 0:
		current_health = 0
		player_died.emit()

	health_changed.emit(current_health) 


func add_item(item: WeaponData) -> bool:
	var _empty_slot = inventory.find(null)
	
	if _empty_slot != -1:
		inventory[_empty_slot] = item
		inventory_updated.emit(_empty_slot, item)
		
		if _empty_slot == active_slot_index:
			active_slot_changed.emit(active_slot_index)
			
		return true
		
	return false

func change_active_slot(index: int) -> void:
	if index < 0 or index >= inventory.size():
		return
	
	active_slot_index = index
	active_slot_changed.emit(active_slot_index)


func load_game_scene():
	get_tree().change_scene_to_file("res://scenes/PUEBLO/PuebloPrincipal.tscn")

func quit_game():
	get_tree().quit()

