extends Node

class_name Entity

@export var HEALTH: float = 100.0
@export var SPEED: float = 2.0
@export var ATTACK_DAMAGE: float = 15.0 ## The base attack damage
@export var ATTACK_DELAY: float = 2.0 ## The delay between attacks in seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
