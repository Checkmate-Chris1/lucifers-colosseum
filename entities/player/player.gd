extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER: Node3D

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
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	_update_camera(delta)

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
