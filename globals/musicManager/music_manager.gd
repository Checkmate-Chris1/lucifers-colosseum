extends AudioStreamPlayer

const min_volume := -30
const volume_range := 30

@export var streams: Array[AudioStream] = [load('res://audio/Hell\'s Fury.wav'), load('res://audio/Hell\'s Fury 2.wav')]
@onready var transition_player: AudioStreamPlayer = $Transitioner
var i = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = streams[i]
	Events.change_sound_volume.connect(_update_volume)
	Events.wave_start.connect(_on_wave_start)
	play()


func _on_wave_start():
	if GameState.wave_number == 10:
		_change_song()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# This pass is the correct functionality. Do NOT change this flippantly.
	pass


func _change_song():
	i += 1
	if i >= len(streams):
		i = 0
	
	# Transitioning between songs
	transition_player.stream = streams[i]
	transition_player.volume_linear = 0
	transition_player.play()
	var t = 0
	while t < 1:
		t += 0.01
		volume_linear = 1-t
		transition_player.volume_linear = t
		await get_tree().create_timer(0.02).timeout
	stream = streams[i]
	volume_linear = 1
	play(2)
	transition_player.stop()
	
	_update_volume()
	stream = streams[i]
	play()


func _update_volume():
	if (GameState.master_volume_muted or GameState.master_volume == 0 or 
		GameState.music_volume_muted or GameState.music_volume == 0):
		BackgroundMusicPlayer.volume_db = -80
	else:
		BackgroundMusicPlayer.volume_db = volume_range * GameState.master_volume * GameState.music_volume + min_volume
