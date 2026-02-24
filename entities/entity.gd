extends CharacterBody3D


class_name Entity

signal died

@export var HEALTH: float = 100.0
@onready var current_health: float = HEALTH:
	set(value):
		current_health = clamp(value, 0, HEALTH)
		if current_health <= 0:
			died.emit()

# burn effect state
var burn_time: float = 0.0
var burn_dps: float = 0.0

func damage(health: float):
	current_health -= health
	print(current_health)

func apply_burn(dps: float, duration: float) -> void:
	# reset timer when re-applied
	burn_dps = dps
	burn_time = duration

func _process(delta: float) -> void:
	if burn_time > 0.0:
		damage(burn_dps * delta)
		burn_time -= delta
	
func heal(health: float):
	current_health += health

func apply_knockback(direction: Vector3, force: float) -> void:
#	TODO: knockback does not work
	var knockback_velocity = direction.normalized() * force
	velocity = knockback_velocity
