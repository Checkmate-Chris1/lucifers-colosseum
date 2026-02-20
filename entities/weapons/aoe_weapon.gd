class_name AOEWeapon extends Weapon

# AOE-specific attributes
@export var aoe_range: float = 8.0
@export var cone_angle: float = 45.0  # degrees
@export var stream_duration: float = 4.0
@export var stream_cooldown: float = 5.0
@export var dps: float = 25.0  # damage per second
@export var burn_damage_per_second: float = 3.0
@export var burn_duration: float = 2.5

func _init(
	p_name: String = "",
	p_max_ammo: int = 1,
	p_aoe_range: float = 8.0,
	p_cone_angle: float = 45.0,
	p_stream_duration: float = 4.0,
	p_dps: float = 25.0
) -> void:
	super(p_name, "aoe", p_max_ammo)
	aoe_range = p_aoe_range
	cone_angle = p_cone_angle
	stream_duration = p_stream_duration
	dps = p_dps
	fire_delay = stream_cooldown
