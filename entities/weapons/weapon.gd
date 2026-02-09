class_name Weapon extends Resource

@export var weapon_name: String
@export var ammo: int
@export var max_ammo: int
@export var fire_delay: float = 0.2
@export var reload_delay: float = 1.0
@export var weapon_type: String  # "projectile" or "raycast"
@export var model: PackedScene
@export var bullet_scene: PackedScene
@export var range: float = 99.0

func _init(p_name: String = "", p_type: String = "", p_max_ammo: int = 10) -> void:
	weapon_name = p_name
	weapon_type = p_type
	max_ammo = p_max_ammo
	ammo = max_ammo
