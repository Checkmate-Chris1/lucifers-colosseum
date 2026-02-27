extends AudioStreamPlayer

@export var streams = [load('res://audio/musicPlaceholder2.mp3'), load('res://audio/musicPlaceholder.mp3')]
var i = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = streams[i]
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _change_song():
	i += 1
	if i >= len(streams):
		i = 0
	stream = streams[i]
	play()
