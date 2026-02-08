extends CharacterBody3D


var player: Node = null

@export var SPEED: float = 2.0
@export var ATTACK_DAMAGE: float = 15.0 ## The base attack damage
@export var ATTACK_DELAY: float = 2.0 ## The delay between attacks in seconds
var attack_ready := true ## If another attack is ready

@onready var nav_agent = $NavigationAgent3D
@export var glb_import: Node3D
@onready var player = get_tree().get_first_node_in_group('player')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Animations
	var animation_player: AnimationPlayer = glb_import.get_node("AnimationPlayer")
	animation_player.play("Idle") # idle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = Vector3.ZERO
	nav_agent.target_position = player.global_position
	var next_point = nav_agent.get_next_path_position()
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	velocity = (next_point - global_position).normalized() * SPEED
	
	move_and_slide()
	
func _process(delta: float) -> void:
	# Attempt to attack
	if attack_ready:
		attack()
	
func attack():
	var entities = $AttackArea.get_overlapping_bodies()
	for entity in entities:
		if entity.is_in_group("player"):
			entity.find_child("HealthComponent").current_health -= ATTACK_DAMAGE
			attack_ready = false
			get_tree().create_timer(ATTACK_DELAY).timeout.connect(func(): attack_ready = true)
