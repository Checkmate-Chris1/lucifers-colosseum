extends Node3D

@onready var player = $Player
@onready var health_bar = $HealthBar 

func _ready():
	health_bar.init_health(player.current_health, player.HEALTH)
