extends Enemy


@onready var nav_agent = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group('player')

var DASH_MULTIPLIER := 5
var BASE_VELOCITY : float = 6.0

var dash_ready : bool = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player != null:
		velocity = Vector3.ZERO
		nav_agent.target_position = player.global_position
		var next_point = nav_agent.get_next_path_position()
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		velocity = (next_point - global_position).normalized() * SPEED
		
		if dash_ready:
			_dash()
		
		
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
	dash_ready = false
	
	# play a little animation to show its about to dash perhaps?
	#await get_tree().create_timer(0.2).timeout
	
	
	var dash_direction : Vector3 = _get_dash_direction()
	look_at(dash_direction, Vector3.UP)
	
	velocity = velocity * DASH_MULTIPLIER
	await get_tree().create_timer(0.25).timeout
	velocity = velocity / DASH_MULTIPLIER
	
	
	var cooldown : float = randf_range(3.0, 6.0)
	await get_tree().create_timer(cooldown).timeout
	dash_ready = true
	
	
	
	
	
