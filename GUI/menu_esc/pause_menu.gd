extends Control

@onready var resume_btn = $VBoxContainer/ResumeBtn
@onready var menu_btn = $VBoxContainer/MenuBtn

func _ready():
	visible = false

	resume_btn.pressed.connect(_on_resume_pressed)
	menu_btn.pressed.connect(_on_menu_pressed)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	var is_paused = not get_tree().paused
	get_tree().paused = is_paused
	
	visible = is_paused
	
	if is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_resume_pressed():
	toggle_pause()

func _on_menu_pressed():
	get_tree().paused = false
	
	get_tree().change_scene_to_file("res://GUI/Menu/main_menu.tscn")
