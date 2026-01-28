extends CharacterBody3D

const SPEED = 4.0
var player = null

@onready var nav_agent = $NavigationAgent3D
@export var player_parent : NodePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_root = get_node(player_parent)
	player = player_root.get_node("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:	
	velocity = Vector3.ZERO
	nav_agent.target_position = player.global_position
	var next_point = nav_agent.get_next_path_position()
	velocity = (next_point - global_position).normalized() * SPEED
	
	move_and_slide()
