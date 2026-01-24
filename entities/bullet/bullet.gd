extends Area2D

var _speed: float = 350
		
var direction: Vector2 = Vector2.RIGHT

var player_inertia: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += ((direction * _speed) + player_inertia) *  delta
	

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
