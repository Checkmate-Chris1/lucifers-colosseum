extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.player_dashed.connect(_play_dash)

func _play_dash():
	$dashSFX.play()
	
