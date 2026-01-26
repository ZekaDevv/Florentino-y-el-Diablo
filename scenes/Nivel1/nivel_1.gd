extends Node2D

@onready var player = $Player
@onready var heart_container = $HUD

func _ready():
	heart_container.set_max(player.health_component.max_health)

	heart_container.update_heart(player.health_component.current_health)

	player.health_component.health_changed.connect(heart_container.update_heart)
