extends Node

var music_volume: float = 1.0
var sfx_volume: float = 1.0

func load_game_scene():
	get_tree().change_scene_to_file("res://scenes/Escenas Jhonder/sala_1_josuess.tscn")

func quit_game():
	get_tree().quit()
