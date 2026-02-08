extends Node3D

@export var STARTING_HEALTH: float = 150.0
var current_health: float = STARTING_HEALTH:
	set(value):
		current_health = clamp(value, 0, STARTING_HEALTH)
		if current_health <= 0:
			Events.game_over.emit()
		print("New player health:", current_health)
