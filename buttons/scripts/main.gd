extends Node3D

@onready var player = $Player
@onready var health_bar = $HealthBar 

func _ready():
	health_bar.init_health(player.current_health, player.HEALTH)
	player.health_changed.connect(health_bar._set_health)
	if player.has_signal("max_health_changed"):
		player.max_health_changed.connect(health_bar._set_max_health)
