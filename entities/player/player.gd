extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const BASE_FOV = 75.0
const DASH_CD = 1

var input_dir : Vector2
var direction : Vector3

@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER: Node3D

@onready var slam_area: Area3D = $SlamArea
@onready var slam_visual: MeshInstance3D = $SlamArea/SlamVFX
var is_ground_slamming := false
var start_y = 0.0

var input_lock := false #use this variable when the player shouldnt have control of their character
var deceleration_lock := false #use this to temporarily stop the character from decelerating

var speed_multiplier := SPEED
var is_dashing := false


var mouse_input := false
var camera_rotation := Vector3.ZERO
var rotation_input: float
var tilt_input: float

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Events.respawn.connect(_respawn)

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
		start_y = global_position.y
		velocity.y = 2 * -JUMP_VELOCITY
		
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
		#allows us to not decelerate while as long as the deceleration lock is true
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	# slam damage logic
	if is_ground_slamming and is_on_floor():
		var fall_height = start_y - global_position.y
		fall_height = max(fall_height, 0)
		is_ground_slamming = false
		slam_visual.visible = true
		var tween := get_tree().create_tween()
		tween.tween_interval(.2)
		tween.tween_callback(func(): slam_visual.visible = false)
		#TODO: calculate damage using fall_height
		_apply_slam_damage(fall_height * GameState.slam_multiplier)
	_update_camera(delta)

func _dash():
	# TO DO: ADD FOV adjustments during the dash
	var _camera := get_viewport().get_camera_3d()
	var zoom_out_speed := 0.1   # Adjusts how QUICKLY fov zooms in when dashing
	var zoom_in_speed  := 0.25  # Adjusts how QUICKLY fov zooms out when dashing
	var fov_increase   := 10    # Adjusts how MUCH fov zooms out when dashing
	var dash_time      := 0.25  # Adjusts how LONG the player dashes for
	var speed_increase := 5     # Adjusts how FAST the player dashes
	
	is_dashing = true
	input_lock = true
	deceleration_lock = true
	speed_multiplier *= speed_increase
	
	var tween = get_tree().create_tween()
	tween.tween_property(_camera, "fov", BASE_FOV + fov_increase, zoom_out_speed)
	
	await get_tree().create_timer(dash_time).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(_camera, "fov", BASE_FOV, zoom_in_speed)
	
	speed_multiplier = SPEED
	deceleration_lock = false
	input_lock = false
	
	await get_tree().create_timer(DASH_CD).timeout
	is_dashing = false
	
func _apply_slam_damage(damage: float) -> void:
	print("Ground slam damage:", damage)
	var collided := slam_area.get_overlapping_bodies()
	for body in collided:
		#TODO: change "take_damage" to appropriate method
		if body.has_method("take_damage"):
			body.take_damage(damage)
	
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
