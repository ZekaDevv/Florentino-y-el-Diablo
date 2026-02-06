extends StaticBody2D


@export var npc_name: String = "NPC"
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

@onready var sprite_animation = $AnimatedSprite2D
@onready var interact_icon = $InteractIcon
var player_in_range: bool = false

func _ready():
	sprite_animation.play("idle")
	interact_icon.visible = false
	
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)

	
func _process(_delta):
	if player_in_range and not GameManager.is_dialog_active:
		if Input.is_action_just_pressed("interact"):
			start_dialogue()


func start_dialogue():
	GameManager.is_dialog_active = true
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_dialogue_finished(_resource):
	await get_tree().create_timer(0.2).timeout
	GameManager.is_dialog_active = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		interact_icon.play("idle")
		interact_icon.visible = true
	else:
		print("Entró algo, pero NO tiene el grupo 'player'")
		
func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		interact_icon.stop()
		interact_icon.visible = false
