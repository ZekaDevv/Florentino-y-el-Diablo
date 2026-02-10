extends Control

@onready var slider_master: HSlider = $MarginContainer/HBoxContainer/LeftColumn/OptionsContainer/GridContainer/SliderMaster
@onready var slider_music: HSlider = $MarginContainer/HBoxContainer/LeftColumn/OptionsContainer/GridContainer/SliderMusic
@onready var slider_sfx: HSlider = $MarginContainer/HBoxContainer/LeftColumn/OptionsContainer/GridContainer/SliderSFX

@onready var buttons_container: VBoxContainer = $MarginContainer/HBoxContainer/LeftColumn/ButtonsContainer
@onready var options_container: VBoxContainer = $MarginContainer/HBoxContainer/LeftColumn/OptionsContainer 


func _ready():
	
	options_container.visible = false
	buttons_container.visible = true

	slider_master.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	slider_music.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	slider_sfx.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))




func _on_btn_play_pressed() -> void:
	GameManager.load_game_scene()


func _on_btn_options_pressed() -> void:
	options_container.visible = true
	buttons_container.visible = false


func _on_btn_exit_pressed() -> void:
	GameManager.quit_game()


func _on_btn_back_pressed() -> void:
	buttons_container.visible = true
	options_container.visible = false


func _change_volume(bus_name: String, value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	
	if value <= 0.05:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
