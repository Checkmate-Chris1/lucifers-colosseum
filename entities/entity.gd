extends CharacterBody3D


class_name Entity

signal died
signal health_changed(new_health)

@export var model_root: Node3D

@export var HEALTH: float = 100.0

var hit_flash_material = preload("res://entities/enemies/hit_flash.tres")
var meshes: Array[MeshInstance3D] = []

@onready var current_health: float = HEALTH:
	set(value):
		current_health = clamp(value, 0, HEALTH)
		health_changed.emit(current_health)
		if current_health <= 0:
			died.emit()
			Events.enemy_died.emit()

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
		
func flash_red():
	for mesh in meshes:
		mesh.material_overlay = hit_flash_material
		
	await get_tree().create_timer(0.1).timeout
	
	for mesh in meshes:
		mesh.material_overlay = null		
		
func damage(health: float, source: String = "weapon"):
	current_health -= health
	flash_red()
	if source == "burn" or source == "enemy":
		return
	
	Events.damaged.emit()

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
