extends AudioStreamPlayer

const min_volume := -30
const volume_range := 30

@export var streams = [load('res://audio/Hell\'s Fury.wav'), load('res://audio/Hell\'s Fury 2.wav')]
var i = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = streams[i]
	Events.change_sound_volume.connect(_update_volume)
	Events.wave_start.connect(_on_wave_start)
	play()


func _on_wave_start():
	print(GameState.wave_number)
	if GameState.wave_number == 10:
		volume_db = -10 # Lvl. 2 wave music is kinda loud
		_change_song()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# This pass is the correct functionality. Do NOT change this flippantly.
	pass


func _change_song():
	i += 1
	if i >= len(streams):
		i = 0
	stream = streams[i]
	play()


func _update_volume():
	if (GameState.master_volume_muted or GameState.master_volume == 0 or 
		GameState.music_volume_muted or GameState.music_volume == 0):
		BackgroundMusicPlayer.volume_db = -80
	else:
		BackgroundMusicPlayer.volume_db = volume_range * GameState.master_volume * GameState.music_volume + min_volume
