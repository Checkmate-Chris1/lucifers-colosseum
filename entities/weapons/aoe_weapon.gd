class_name AOEWeapon extends Weapon

# AOE-specific attributes
@export var aoe_range: float = 8.0
@export var cone_angle: float = 45.0  # degrees
@export var burn_damage_per_second: float = 3.0
@export var burn_duration: float = 2.5

func _init(
	p_name: String = "",
	p_max_ammo: int = 1,
	p_aoe_range: float = 8.0,
	p_cone_angle: float = 45.0,
	p_fire_delay: float = 0.2
) -> void:
	super(p_name, "aoe", p_max_ammo)
	aoe_range = p_aoe_range
	cone_angle = p_cone_angle
	fire_delay = p_fire_delay
