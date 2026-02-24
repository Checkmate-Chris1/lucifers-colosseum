extends Enemy


@export var FLOATING_HEIGHT := 2.4
@export var KEEP_DISTANCE := 1.5
@export var HOVER_FORCE := 6.0
@export var DAMPING := 6.0

@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if player == null:
		queue_free()
		return


	var look_pos = Vector3(player.global_position.x, global_position.y, player.global_position.z)
	look_at(look_pos, Vector3.UP)

	var enemy_flat = Vector3(global_position.x, 0, global_position.z)
	var player_flat = Vector3(player.global_position.x, 0, player.global_position.z)

	var distance = enemy_flat.distance_to(player_flat)

	if distance > KEEP_DISTANCE:
		var dir = (player_flat - enemy_flat).normalized()
		velocity.x = lerp(velocity.x, dir.x * SPEED, delta * DAMPING)
		velocity.z = lerp(velocity.z, dir.z * SPEED, delta * DAMPING)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * DAMPING)
		velocity.z = lerp(velocity.z, 0.0, delta * DAMPING)
		attack()

	var height_error = FLOATING_HEIGHT - global_position.y
	velocity.y = height_error * HOVER_FORCE

	move_and_slide()
