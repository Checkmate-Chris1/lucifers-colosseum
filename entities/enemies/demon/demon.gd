<<<<<<< Updated upstream
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
=======
extends Enemy


@onready var nav_agent = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group('player')

const FLOATING_HEIGHT := 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player != null:
		velocity = Vector3.ZERO
		nav_agent.target_position = player.global_position
		var next_point = nav_agent.get_next_path_position()
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		velocity = (next_point - global_position).normalized() * SPEED
		
		global_position.y = FLOATING_HEIGHT
		
		attack()
		move_and_slide()
	else:
		# only occurs when exiting game
		queue_free()
>>>>>>> Stashed changes
