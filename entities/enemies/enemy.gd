extends Entity


class_name Enemy

@export var SPEED: float = 2.0
@export var ATTACK_DAMAGE: float = 15.0 ## The base attack damage
@export var ATTACK_DELAY: float = 2.0 ## The delay between attacks in seconds
@export var attack_collision_box: Area3D

var attack_ready := true ## If another attack is ready

func _init() -> void:
	died.connect(queue_free) # All enemies should be removed from the scene upon death

func attack():
	if attack_ready:
		var within_attack = attack_collision_box.get_overlapping_bodies()
		for entity in within_attack:
			if entity is Player:
				entity.damage(ATTACK_DAMAGE)
				attack_ready = false
				get_tree().create_timer(ATTACK_DELAY).timeout.connect(func(): attack_ready = true)
