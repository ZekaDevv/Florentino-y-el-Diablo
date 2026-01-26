extends CanvasLayer

@export var heart_gui_scene: PackedScene
@onready var container = $HeartContainer

func set_max(max: int) -> void: 
	for child in container.get_children():
		child.queue_free()

	for i in range(max):
		var heart = heart_gui_scene.instantiate()
		container.add_child(heart)

func update_heart(current_health: int) -> void:
	var hearts = container.get_children()

	for i in range(hearts.size()):
		if i < current_health:
			hearts[i].update(true)
		else:
			hearts[i].update(false)
