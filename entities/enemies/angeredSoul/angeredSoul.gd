extends Enemy


@onready var nav_agent = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group('player')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player != null:
		velocity = Vector3.ZERO
		nav_agent.target_position = player.global_position
		var next_point = nav_agent.get_next_path_position()
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		velocity = (next_point - global_position).normalized() * SPEED
		
		attack()
		move_and_slide()
	else:
		# only occurs when exiting game
		queue_free()
	
	
func _get_dash_direction() -> Vector3:
	velocity = velocity * 5
	var rotate_range = randf_range(-30, 30)
	var target_var = "x" if randi_range(0, 1) == 1 else "z"
	var ret_val : Vector3
	if target_var == "x":
		ret_val = Vector3(player.global_position.x + rotate_range, player.global_position.y, player.global_position.z)
	elif target_var == "z":
		ret_val = Vector3(player.global_position.x, player.global_position.y, player.global_position.z + rotate_range)

	return ret_val
		
	
func _dash():
	var dash_direction : Vector3 = _get_dash_direction()
	
	
	
	
	
