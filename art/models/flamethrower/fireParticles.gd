extends GPUParticles3D

var showing_fire := false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_fire"):
		showing_fire = not showing_fire
		set_show_particles(showing_fire)

func set_show_particles(val: bool):
	visible = val
