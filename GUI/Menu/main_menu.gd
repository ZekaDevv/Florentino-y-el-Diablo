extends Control

@onready var slider_master: HSlider = $OptionsMenu/VBoxContainer/GridContainer/SliderMaster
@onready var slider_music: HSlider = $OptionsMenu/VBoxContainer/GridContainer/SliderMusic
@onready var slider_sfx: HSlider = $OptionsMenu/VBoxContainer/GridContainer/SliderSFX

@onready var options_menu: Control = $OptionsMenu
@onready var main_container: Container = $MarginContainer


func _ready():
	options_menu.visible = false
	main_container.visible = true

	slider_master.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	slider_music.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	slider_sfx.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))




func _on_btn_play_pressed() -> void:
	GameManager.load_game_scene()


func _on_btn_options_pressed() -> void:
	options_menu.visible = true
	main_container.visible = false


func _on_btn_exit_pressed() -> void:
	GameManager.quit_game()




func _on_btn_back_pressed() -> void:
	options_menu.visible = false
	main_container.visible = true


func _change_volume(bus_name: String, value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	
	if value <= 0.05:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
