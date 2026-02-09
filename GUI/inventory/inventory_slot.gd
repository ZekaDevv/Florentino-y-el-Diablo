extends Panel

@onready var icon_texture: TextureRect = $Icon
@onready var highlight: ReferenceRect = $ActiveHighlight

func update_icon(item: WeaponData)  -> void:
	if item != null:
		icon_texture.texture = item.icon
		icon_texture.visible = true
	else:
		icon_texture.texture = null
		icon_texture.visible = false

func set_selected(is_selected: bool):
	highlight.visible = is_selected
