extends CharacterBody3D


class_name Entity

signal died

@export var HEALTH: float = 100.0
var current_health: float = HEALTH:
	set(value):
		current_health = clamp(value, 0, HEALTH)
		if current_health <= 0:
			died.emit()

func damage(health: float):
	current_health -= health
	
func heal(health: float):
	current_health += health
