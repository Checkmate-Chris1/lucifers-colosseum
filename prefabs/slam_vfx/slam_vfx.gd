extends Area3D


# Called upon instantiation, handles its own lifetime
func _ready() -> void:
	scale = scale * Vector3(GameState.slam_size, 1, GameState.slam_size)
	$Particles.emitting = true
	await get_tree().create_timer(5).timeout
	queue_free()
