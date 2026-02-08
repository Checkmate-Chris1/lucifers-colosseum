extends Node3D

@export var STARTING_HEALTH: float = 100.0
@onready var current_health: float = STARTING_HEALTH:
	set(value):
		current_health = clamp(value, 0, STARTING_HEALTH)
		if current_health <= 0:
			get_parent().queue_free()
