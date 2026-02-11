extends Node2D

@onready var player = $Player
@onready var tilemap = $Floor
@onready var heart_container = $HUD

var villaje_music = preload("res://assets/audio/moliendo_café.mp3")

func _ready() -> void:
	MusicController.play_music(villaje_music)

	
	var map_react = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.tile_size
	
	var camera = player.get_node("Camera2D")
	
	var local_top_left = map_react.position * tile_size
	var local_bottom_right = (map_react.position + map_react.size) * tile_size
	var global_top_left = tilemap.to_global(local_top_left)
	var global_bottom_right = tilemap.to_global(local_bottom_right)
	
	
	camera.limit_left = int(global_top_left.x)
	camera.limit_top = int(global_top_left.y)
	camera.limit_right = int(global_bottom_right.x)
	camera.limit_bottom = int(global_bottom_right.y)
