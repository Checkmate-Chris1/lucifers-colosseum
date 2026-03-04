extends CharacterBody3D


class_name Entity

signal died
signal health_changed(new_health)

@export var model_root: Node3D


var death_emitted := false

# creating iframes for the player
var invincible := false
var is_player := false
var player_hit_invincibility_time := 0.5

@export var HEALTH: float = 100.0

# damage numvber
@export var damage_text_height: float = 1.0

var damage_label: Label3D
var accumulated_damage: float = 0.0
var damage_tween: Tween

# hit material
var hit_flash_material = preload("res://entities/enemies/hit_flash.tres")
var meshes: Array[MeshInstance3D] = []

@onready var current_health: float = HEALTH:
	set(value):
		current_health = clamp(value, 0, HEALTH)
		health_changed.emit(current_health)
		if current_health <= 0 and not death_emitted:
			died.emit()
			Events.enemy_died.emit()
			death_emitted = true

# burn effect state
var burn_time: float = 0.0
var burn_dps: float = 0.0
var burn_tick_timer: float = 0.0

func _gather_meshes(node: Node):
	if node is MeshInstance3D:
		meshes.append(node)
	for child in node.get_children():
		_gather_meshes(child)
		
func _ready() -> void:
	if model_root:
		_gather_meshes(model_root)
	damage_label = Label3D.new()
	add_child(damage_label)
	damage_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	damage_label.no_depth_test = true
	damage_label.font_size = 64
	damage_label.modulate.a = 0.0
	damage_label.modulate = Color(1,0,0)
	damage_label.position.y = damage_text_height
		
func flash_red():
	for mesh in meshes:
		mesh.material_overlay = hit_flash_material
		
	await get_tree().create_timer(0.1).timeout
	
	for mesh in meshes:
		mesh.material_overlay = null		

func show_damage_number(amount: float):
	accumulated_damage += amount
	if damage_label:
		damage_label.text = "-" + str(round(accumulated_damage))
		
		if damage_tween and damage_tween.is_valid():
			damage_tween.kill()
			
		damage_tween = create_tween()
		
		damage_label.modulate.a = 1.0
		damage_label.position.y = damage_text_height
		
		var target_height = damage_text_height
		damage_tween.tween_property(damage_label, "position:y", target_height, 1.5).set_ease(Tween.EASE_OUT)
		damage_tween.parallel().tween_property(damage_label, "modulate:a", 0.0, 0.5).set_delay(1.0)
		damage_tween.tween_callback(func(): accumulated_damage = 0.0)
	
func damage(health: float, source: String = "weapon"):
	flash_red()
	show_damage_number(health)
	current_health -= health

	if source == "burn" or source == "enemy":
		return
	
	Events.damaged.emit()

func momentary_invincibility():
	if is_player:
		invincible = true
		print(invincible)
		await get_tree().create_timer(player_hit_invincibility_time).timeout
		invincible = false
		print(invincible)
		

func apply_burn(dps: float, duration: float) -> void:
	# reset timer when re-applied
	burn_dps = dps
	burn_time = duration

func _process(delta: float) -> void:
	if burn_time > 0.0:
		burn_time -= delta
		burn_tick_timer += delta
		if burn_tick_timer >= 1.0:
			damage(burn_dps, "burn")
			burn_tick_timer -= 1.0
	
func heal(health: float):
	current_health += health

func apply_knockback(direction: Vector3, force: float) -> void:
#	TODO: knockback does not work
	var knockback_velocity = direction.normalized() * force
	velocity = knockback_velocity
