extends CharacterBody3D


class_name Entity

signal died
signal health_changed(new_health)

@export var HEALTH: float = 100.0
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

func damage(health: float, source: String = "weapon"):
	current_health -= health
	
	if source == "burn" or source == "enemy":
		return
	
	Events.damaged.emit()

func apply_burn(dps: float, duration: float) -> void:
	# reset timer when re-applied
	burn_dps = dps
	burn_time = duration

func _process(delta: float) -> void:
	if burn_time > 0.0:
		damage(burn_dps * delta, "burn")
		burn_time -= delta
	
func heal(health: float):
	current_health += health

func apply_knockback(direction: Vector3, force: float) -> void:
#	TODO: knockback does not work
	var knockback_velocity = direction.normalized() * force
	velocity = knockback_velocity
