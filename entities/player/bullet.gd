extends CharacterBody3D

@export var speed := 50.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_direction(dir: Vector3) -> void:
	print('setting direction? ' + str(dir))

func _physics_process(delta: float) -> void:
	var velocity = -global_transform.basis.z * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		# handle collision
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
