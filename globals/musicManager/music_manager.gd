extends AudioStreamPlayer

const min_volume := -30
const volume_range := 30

@export var streams = [load('res://audio/musicPlaceholder2.mp3'), load('res://audio/musicPlaceholder.mp3')]
var i = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = streams[i]
	Events.change_sound_volume.connect(_update_volume)
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_music"):
		stream_paused = not stream_paused
	elif Input.is_action_just_pressed("change_music"):
		_change_song()


func _change_song():
	i += 1
	if i >= len(streams):
		i = 0
	stream = streams[i]
	play()


func _update_volume():
	if GameState.master_volume == 0 or GameState.music_volume == 0:
		BackgroundMusicPlayer.volume_db = -80
	else:
		BackgroundMusicPlayer.volume_db = volume_range * GameState.master_volume * GameState.music_volume + min_volume
