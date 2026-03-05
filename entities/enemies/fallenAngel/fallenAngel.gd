extends Enemy

@export var chasing_distance: float = 4.0

@onready var nav_agent = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group('player')

func _ready():
	super()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_dead:
		return
	velocity = Vector3.ZERO
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	if position.distance_to(player.position) >= chasing_distance:
		nav_agent.target_position = player.global_position
		var next_point = nav_agent.get_next_path_position()
		velocity = (next_point - global_position).normalized() * SPEED
		
		move_and_slide()
	attack()
