class_name MeleeWeapon extends Weapon

# Melee-specific attributes
@export var melee_range: float = 5.0
@export var knockback_distance: float = 2.0
@export var attack_cooldown: float = 1.5

func _init(
	p_name: String = "",
	p_max_ammo: int = 1,
	p_damage: float = 35.0,
	p_melee_range: float = 5.0,
	p_knockback: float = 2.0,
	p_cooldown: float = 1.5
) -> void:
	super(p_name, "melee", p_max_ammo)
	bullet_damage = p_damage
	melee_range = p_melee_range
	knockback_distance = p_knockback
	attack_cooldown = p_cooldown
	fire_delay = p_cooldown
