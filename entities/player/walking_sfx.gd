extends AudioStreamPlayer

const min_volume := -30
const volume_range := 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_db = min_volume + volume_range
	Events.change_sound_volume.connect(_update_volume)

func _update_volume():
	if GameState.master_volume == 0 or GameState.sfx_volume == 0:
		volume_db = -80
	else:
		volume_db = volume_range * GameState.master_volume * GameState.sfx_volume + min_volume
