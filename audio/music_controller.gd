extends Node

@onready var player = $MusicPlayer
	
var normal_volume_db = 0.0
var ducking_volume_db = -30.0

func _ready():
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


func play_music(song_stream: AudioStream):
	if player.stream == song_stream and player.playing:
		return
	
	player.stream = song_stream
	player.play()

func stop_music():
	player.stop()


func _on_dialogue_started(_resource):
		var tween = create_tween()
		tween.tween_property(player , "volume_db", ducking_volume_db, 1.0)
		
func _on_dialogue_ended(_resource):
		var tween = create_tween()
		tween.tween_property(player, "volume_db", normal_volume_db, 1.0)
