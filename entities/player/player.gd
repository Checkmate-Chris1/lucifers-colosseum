extends Entity


class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var input_dir : Vector2
var direction : Vector3

@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER: Node3D
@export var slam_vfx: PackedScene

var is_ground_slamming := false
var start_y = 0.0

var input_lock := false # use this variable when the player shouldnt have control of their character
var deceleration_lock := false # use this to temporarily stop the character from decelerating

var speed_multiplier := SPEED
var speed_boost := 0.0

# percent trackers
var health_total_percent := 0
var gp_radius_total_percent := 0
var gp_dmg_total_percent := 0
var speed_total_percent := 0
var is_dashing := false

var mouse_input := false
var camera_rotation := Vector3.ZERO
var rotation_input: float
var tilt_input: float

@onready var walking_audio_player: AudioStreamPlayer = $WalkingSFX

signal max_health_changed(new_max : float)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Events.respawn.connect(_respawn)
	died.connect(Events.game_over.emit) # Relays player death as game over

	# upgrade listeners
	Events.UPGR_p_max_health_up.connect(_on_max_health_up)
	Events.UPGR_p_gp_radius_up.connect(_on_gp_radius_up)
	Events.UPGR_p_gp_dmg_up.connect(_on_gp_dmg_up)
	Events.UPGR_p_speed_up.connect(_on_speed_up)

	# cumulative percent trackers
	health_total_percent = 0
	gp_radius_total_percent = 0
	gp_dmg_total_percent = 0
	speed_total_percent = 0
	
	# update some entity variables
	is_player = true

func _physics_process(delta: float) -> void:
	# DEBUG: Quit
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("slam") and not is_on_floor() and not is_ground_slamming:
		is_ground_slamming = true
		if is_ground_slamming == true:
			invincible = true
		start_y = global_position.y
		velocity.y = 2 * -JUMP_VELOCITY
	
	if is_walking() and not walking_audio_player.playing:
		walking_audio_player.play()
	
	var is_moving_horizontal := (velocity.x != 0) or (velocity.z != 0)
	if Input.is_action_just_pressed("dash") and not is_dashing and is_moving_horizontal:
		_dash()
	
	if not input_lock:
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed_multiplier
		velocity.z = direction.z * speed_multiplier
		
	elif not deceleration_lock:
		# allows us to not decelerate while as long as the deceleration lock is true
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	# slam damage logic
	if is_ground_slamming and is_on_floor():
		var fall_height = start_y - global_position.y
		fall_height = max(fall_height, 0)
		is_ground_slamming = false
		var vfx = slam_vfx.instantiate()
		vfx.position = position # Offsets to player's feet
		add_sibling(vfx)
		# TODO: calculate damage using fall_height
		_apply_slam_damage(vfx, fall_height * GameState.slam_multiplier)
		invincible = false
	_update_camera(delta)

func _dash():
	var _camera := get_viewport().get_camera_3d()
	var zoom_out_speed := 0.1   # Adjusts how QUICKLY fov zooms in when dashing
	var zoom_in_speed  := 0.25  # Adjusts how QUICKLY fov zooms out when dashing
	var fov_increase   := 10    # Adjusts how MUCH fov zooms out when dashing
	var dash_time      := 0.25  # Adjusts how LONG the player dashes for
	var speed_increase := 5     # Adjusts how FAST the player dashes
	
	is_dashing          = true
	input_lock          = true
	deceleration_lock   = true
	speed_multiplier   *= speed_increase
	invincible          = true
	set_collision_mask_value(4, false)
	
	Events.player_dashed.emit()
	
	var tween = get_tree().create_tween()
	tween.tween_property(_camera, "fov", GameState.player_fov + fov_increase, zoom_out_speed)
	
	await get_tree().create_timer(dash_time).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(_camera, "fov", GameState.player_fov, zoom_in_speed)
	
	set_collision_mask_value(4, true)
	invincible          = false
	speed_multiplier    = SPEED
	deceleration_lock   = false
	input_lock          = false
	
	
	await get_tree().create_timer(GameState.dash_cd).timeout
	is_dashing = false
	
# Damages all entities within a collider's area by damage
func _apply_slam_damage(collider: Area3D, damage: float) -> void:
	await (get_tree().physics_frame)
	var collided := collider.get_overlapping_bodies()
	for body in collided:
		if body is Enemy:
			body.damage(damage)
	
func _input(event: InputEvent) -> void:
	mouse_input = event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if mouse_input:
		rotation_input = -event.relative.x
		tilt_input = -event.relative.y
	
		
func _update_camera(delta: float) -> void:
	camera_rotation.x += tilt_input * delta * GameState.mouse_sensitivity
	camera_rotation.x = clamp(camera_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	camera_rotation.y += rotation_input * delta * GameState.mouse_sensitivity
	
	CAMERA_CONTROLLER.rotation.x = camera_rotation.x
	CAMERA_CONTROLLER.rotation.y = 0.0
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	self.rotation.y = camera_rotation.y
	
	rotation_input = 0.0
	tilt_input = 0.0

func _respawn() -> void:
	get_tree().reload_current_scene()

func _on_max_health_up(percent: int) -> void:
	# increase base HEALTH and current health by percentage
	health_total_percent += percent
	var increase = HEALTH * percent / 100.0
	HEALTH += increase
	current_health += increase
	print("Health Boost: increased by %d, total: %d" % [percent, health_total_percent])
	# notify UI
	max_health_changed.emit(HEALTH)
	health_changed.emit(current_health)

func _on_gp_radius_up(percent: int) -> void:
	gp_radius_total_percent += percent
	GameState.slam_size *= (1.0 + percent/100.0)
	print("Ground Pound Radius: increased by %d, total: %d" % [percent, gp_radius_total_percent])

func _on_gp_dmg_up(percent: int) -> void:
	gp_dmg_total_percent += percent
	GameState.slam_multiplier *= (1.0 + percent/100.0)
	print("Ground Pound Damage: increased by %d, total: %d" % [percent, gp_dmg_total_percent])

func _on_speed_up(percent: int) -> void:
	speed_total_percent += percent
	var inc = SPEED * percent / 100.0
	speed_boost += inc
	speed_multiplier = SPEED + speed_boost
	print("Speed Boost: increased by %d, total: %d" % [percent, speed_total_percent])

func is_walking():
	var base = SPEED + speed_boost
	return ((velocity.x != 0 or velocity.z != 0) and is_on_floor() and 
			speed_multiplier == base)
			# the last statement is to check if the player is not dashing
			# is_dashing is not a reliable variable for this
