extends GPUParticles3D

var frames_since_last := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	frames_since_last += 1
	emitting = frames_since_last < 5

func fire_on():
	frames_since_last = 0
