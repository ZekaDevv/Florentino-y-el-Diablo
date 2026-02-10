extends Node2D
class_name Weapon

enum ShootPattern {BASE, ARC, RADIAL, DOUBLE, FAN}

@export_group("weapon_configuration")
@export var shoot_pattern: ShootPattern = ShootPattern.BASE
@export var scene_bullet: PackedScene
@export var cooldown: float = 0.25
@export_range(0.0, 1.0) var inertia_factor: float = 0.5

@export_group("pattern_configuration")
@export var bullet_count: int = 1
@export var burst_delay: float = 0
@export var spawn_margin: float = 15.0
@export var arc_spread: float = 40.0
@export_range(0.0, 360.0) var fan_angle: float = 160.0

@export_group("Collision Settings")
@export_flags_2d_physics var attack_mask: int = 0

var can_shoot = true

@onready var muzzle: Marker2D = $Muzzle

func shoot(dir: Vector2, source_velocity: Vector2) -> void:
	if not can_shoot:
		return

	can_shoot = false
	get_tree().create_timer(cooldown).timeout.connect(func(): can_shoot = true)


	match shoot_pattern:
		
		ShootPattern.BASE:
			_spawn_bullet(dir, source_velocity)


		ShootPattern.RADIAL:
			var _angle_step: float = (360.0 / bullet_count)
			
			for i in range(bullet_count):
				var _degrees = _angle_step * i
				var _radians = deg_to_rad(_degrees)
				var _radial_dir = dir.rotated(_radians)

				_spawn_bullet(_radial_dir, source_velocity)
			

		ShootPattern.DOUBLE:
			for i in range(bullet_count):
				var _lateral_vector = dir.rotated(deg_to_rad(90))
				var _half_spread = arc_spread / 2.0
				var _offset_up = _lateral_vector * -(_half_spread)
				_spawn_bullet_offset(dir, source_velocity, _offset_up)

				await get_tree().create_timer(burst_delay).timeout

				var _offset_down = _lateral_vector * _half_spread
				_spawn_bullet_offset(dir, source_velocity, _offset_down)
				

		ShootPattern.FAN:
			var _total_radians = deg_to_rad(fan_angle)
			var _start_angle = -_total_radians / 2.0
			
			var step = 0
			if bullet_count > 1:
				step = _total_radians / (bullet_count - 1)
			
			for i in range(bullet_count):
				var _current_angle = _start_angle + (step * i)
				var _fan_dir = dir.rotated(_current_angle)
				
				_spawn_bullet(_fan_dir, source_velocity)


		ShootPattern.ARC:
			var _lateral_vector = dir.rotated(deg_to_rad(90))
			var _step_distance = arc_spread / max(bullet_count - 1, 1) 
			var _start_offset = -arc_spread / 2.0

			for i in range(bullet_count):
				var _current_lateral_dist = _start_offset + (_step_distance * i)
				var _pos_offset = _lateral_vector * _current_lateral_dist

				var _curve_amount = 10.0
				var _factor = _current_lateral_dist / (arc_spread / 2.0)
				var _forward_offset = dir * (1.0 - (_factor * _factor)) * _curve_amount
				var _final_offset = _pos_offset + _forward_offset

				_spawn_bullet_offset(dir, source_velocity, _final_offset)


func _spawn_bullet(dir: Vector2, source_vel: Vector2) -> void:
	_spawn_bullet_offset(dir, source_vel, Vector2.ZERO)
	
	
func _spawn_bullet_offset(dir: Vector2, source_velocity: Vector2, extra_offset: Vector2) -> void:
	var bullet = scene_bullet.instantiate()
	bullet.direction = dir

	bullet.set_meta("target_mask", attack_mask)

	var _parallel_speed = source_velocity.project(dir)
	var _lateral_velocity = source_velocity - _parallel_speed
	bullet.player_inertia = _lateral_velocity * inertia_factor

	get_tree().current_scene.add_child(bullet)

	var center = muzzle.global_position
	var margen_frontal = dir * spawn_margin
	bullet.global_position = center + margen_frontal + extra_offset
