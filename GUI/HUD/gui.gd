extends CanvasLayer

@export var heart_gui_scene: PackedScene
@onready var container = $HeartContainer

func _ready() -> void: 
	await get_tree().process_frame

	set_max(GameManager.max_health)
	update_heart(GameManager.current_health)

	GameManager.health_changed.connect(update_heart)


func set_max(max: float) -> void: 
	for child in container.get_children():  
		child.free()

	for i in range(max):
		var heart = heart_gui_scene.instantiate()
		container.add_child(heart)

func update_heart(current_health: float) -> void:
	var hearts = container.get_children()

	for i in range(hearts.size()):
		if i < current_health:
			hearts[i].update(true)
		else:
			hearts[i].update(false)
