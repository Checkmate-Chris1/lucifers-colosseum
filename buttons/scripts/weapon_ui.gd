extends Control

@onready var weapon_icon = $MaskPanel/WeaponIcon
@onready var ammo_label = $AmmoLabel
@onready var reload_ring = $ReloadRing
@onready var out_of_ammo_warning = $WarningLayer/OutOfAmmoWarning

var weapon_manager: Node
var current_max_ammo: int = 1
var is_flamethrower_offset_active: bool = false
var warning_tween: Tween

func _ready():
	out_of_ammo_warning.hide()
	
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
	if weapon.weapon_name == "Flamethrower":
		reload_ring.tint_progress = Color(1.0, 0.5, 0.0)
	elif weapon.weapon_name == "Railgun":
		reload_ring.tint_progress = Color(0.6, 0.0, 0.0)
	else:
		reload_ring.tint_progress = Color(1.0, 1.0, 1.0)

func _on_ammo_changed(current_ammo: int, max_ammo: int):
	ammo_label.text = str(current_ammo) + " / " + str(max_ammo)
	current_max_ammo = max_ammo
	reload_ring.max_value = max_ammo
	reload_ring.value = current_ammo

	if current_ammo <= 0:
		_show_out_of_ammo_warning()

func _show_out_of_ammo_warning():
	out_of_ammo_warning.show()
	out_of_ammo_warning.modulate.a = 1.0 
	
	if warning_tween and warning_tween.is_running():
		warning_tween.kill()
		
	warning_tween = create_tween()
	warning_tween.tween_interval(1.5) 
	warning_tween.tween_property(out_of_ammo_warning, "modulate:a", 0.0, 0.5) 
	warning_tween.finished.connect(func(): out_of_ammo_warning.hide())

func _on_reload_started(duration: float):
	out_of_ammo_warning.hide()
	var tween = create_tween()
	tween.tween_property(reload_ring, "value", float(current_max_ammo), duration)
