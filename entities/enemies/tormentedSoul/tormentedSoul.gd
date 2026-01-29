extends CharacterBody3D

const SPEED = 2.0
var player = null

@onready var nav_agent = $NavigationAgent3D
@export var glb_import: Node3D
@export var player_parent : NodePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_root = get_node(player_parent)
	player = player_root.get_node("Player")
	
	# Animations
	var animation_player: AnimationPlayer = glb_import.get_node("AnimationPlayer")
	animation_player.play("Idle") # idle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:	
	velocity = Vector3.ZERO
	nav_agent.target_position = player.global_position
	var next_point = nav_agent.get_next_path_position()
	look_at(Vector3(player.global_position.x, player.global_position.y, player.global_position.z), Vector3.UP)
	velocity = (next_point - global_position).normalized() * SPEED
	
	move_and_slide()
