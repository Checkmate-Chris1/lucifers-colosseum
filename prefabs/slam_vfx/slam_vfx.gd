extends Area3D


# Called upon instantiation, handles its own lifetime
func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	_disappear(0.5)

# Slowly disappears before removing itself
func _disappear(progress: float = 0.5):
	$SlamVFX.transparency = progress
	if progress < 1:
		await get_tree().create_timer(0.01).timeout
		_disappear(progress+0.01)
	else:
		queue_free()
