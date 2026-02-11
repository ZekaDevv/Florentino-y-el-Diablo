extends Node2D
class_name GameRoom

@onready var tilemap = $NavigationRegion2D/Floor
@onready var detector = $PlayerDetector
@onready var enemy_holder = $EnemyHolder

var limit_left: int
var limit_top: int
var limit_right: int
var limit_bottom: int

func _ready():
	detector.body_entered.connect(_on_player_entered)

	var map_rect = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.tile_size
	
	var local_top_left = map_rect.position * tile_size
	var local_bottom_right = (map_rect.position + map_rect.size) * tile_size
	
	var global_top_left = tilemap.to_global(local_top_left)
	var global_bottom_right = tilemap.to_global(local_bottom_right)
	
	limit_left = int(global_top_left.x)
	limit_top = int(global_top_left.y)
	limit_right = int(global_bottom_right.x)
	limit_bottom = int(global_bottom_right.y)

	enemy_holder.process_mode = Node.PROCESS_MODE_DISABLED

func _on_player_entered(body):
	if body.is_in_group("player"):
		var camera = body.get_node("Camera2D")
		
		if camera:
			camera.limit_left = limit_left
			camera.limit_top = limit_top
			camera.limit_right = limit_right
			camera.limit_bottom = limit_bottom
		
		enemy_holder.process_mode = Node.PROCESS_MODE_INHERIT
