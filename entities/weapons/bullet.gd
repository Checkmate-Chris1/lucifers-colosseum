extends CharacterBody3D

@export var speed := 50.0
@export var damage := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(10.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	var velocity = -global_transform.basis.z * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(damage)
		# bullet is deleted on collision
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
