extends Resource
class_name WeaponData

@export_group("Identidad")
@export var name_weapon: String = "Nombre del Arma"
@export var icon: Texture2D 

@export_group("Comportamiento")
@export var weapon_scene: PackedScene
@export var damage: float = 1.0
