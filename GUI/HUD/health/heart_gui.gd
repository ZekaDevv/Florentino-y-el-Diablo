extends Panel

@onready var sprite: Sprite2D = $Sprite2D

var tex_full = preload("res://GUI/HUD/health/full_heart.png")
var tex_empty = preload("res://GUI/HUD/health/empty_hearth.png")
var tex_half = preload("res://GUI/HUD/health/half_heart.png")



func update(whole: bool) -> void:
	if whole:
		sprite.texture =  tex_full
	else:
		sprite.texture =  tex_empty
