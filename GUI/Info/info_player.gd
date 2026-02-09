extends MarginContainer

@onready var name_label: Label = %Label

func _ready():
	await get_tree().process_frame
	name_label.text = GameManager.name_player
	
