extends Node

var music_volume: float = 1.0
var sfx_volume: float = 1.0

var is_dialog_active: bool = false;

func load_game_scene():
	get_tree().change_scene_to_file("res://scenes/Nivel1/Nivel1.tscn")
func quit_game():
	get_tree().quit()
