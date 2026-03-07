extends Enemy

@onready var nav_agent = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group('player')

var BASE_VELOCITY : float = 6.0
var DASH_MULTIPLIER := 5

var dash_ready : bool = true
var is_dashing : bool = false
var dash_direction : Vector3
var dash_speed : float

func _physics_process(delta: float) -> void:
	if player == null:
		queue_free()
		return

	nav_agent.target_position = player.global_position
	var next_point = nav_agent.get_next_path_position()

	if is_dashing:
		velocity = dash_direction * dash_speed
	else:
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		velocity = (next_point - global_position).normalized() * BASE_VELOCITY

		if dash_ready:
			_dash()

	attack()
	move_and_slide() 

func _get_dash_direction() -> Vector3:
	var to_player = (player.global_position - global_position).normalized()
	var angle = deg_to_rad(randf_range(-30, 30))
	var dash_dir = to_player.rotated(Vector3.UP, angle).normalized()
	return dash_dir

func _dash():
	dash_ready = false
	is_dashing = true

	dash_direction = _get_dash_direction()
	dash_speed = BASE_VELOCITY * DASH_MULTIPLIER
	look_at(global_position + dash_direction, Vector3.UP)
	set_collision_mask_value(4, false)
	# Dash lasts 0.25 seconds
	await get_tree().create_timer(0.25).timeout
	is_dashing = false
	set_collision_mask_value(4, true)
	
	var cooldown = randf_range(3.0, 6.0)
	await get_tree().create_timer(cooldown).timeout
	dash_ready = true
	
	
	
