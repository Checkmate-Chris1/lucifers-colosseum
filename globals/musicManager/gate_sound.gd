extends AudioStreamPlayer3D

@export var activation_radius : float = 10.0

var player : Node3D

func _ready() -> void:
	player = get_tree().get_root().get_node("Main/Player")              
	playing = false

func _process(_delta: float) -> void:
	if not player:
		return                     
	var dist := global_transform.origin.distance_to(player.global_transform.origin)
	if dist <= activation_radius:
		if not playing:
			play()
	else:
		if playing:
			stop()
