extends Control

@onready var weapon_icon = $MaskPanel/WeaponIcon
@onready var ammo_label = $AmmoLabel
@onready var reload_ring = $ReloadRing

var weapon_manager: Node
var current_max_ammo: int = 1
var is_flamethrower_offset_active: bool = false

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		weapon_manager = player.get_node("Gun")
		weapon_manager.weapon_changed.connect(_on_weapon_changed)
		weapon_manager.ammo_changed.connect(_on_ammo_changed)
		weapon_manager.reload_started.connect(_on_reload_started)
		if weapon_manager.current_weapon:
			_on_weapon_changed(weapon_manager.current_weapon)
			_on_ammo_changed(weapon_manager.current_weapon.ammo, weapon_manager.current_weapon.max_ammo)

func _on_weapon_changed(weapon: Weapon):
	if weapon.icon:
		weapon_icon.texture = weapon.icon
	if weapon.weapon_type == "projectile":
		weapon_icon.texture = null
	if weapon.weapon_type in ["projectile", "raycast", "aoe"]:
		ammo_label.show()
	else:
		ammo_label.hide()

func _on_ammo_changed(current_ammo: int, max_ammo: int):
	ammo_label.text = str(current_ammo) + " / " + str(max_ammo)
	current_max_ammo = max_ammo
	reload_ring.max_value = max_ammo
	reload_ring.value = current_ammo

func _on_reload_started(duration: float):
	var tween = create_tween()
	tween.tween_property(reload_ring, "value", float(current_max_ammo), duration)
