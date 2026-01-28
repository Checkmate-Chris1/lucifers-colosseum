extends Node3D
@export var speed : Vector3 = Vector3(0, 25, 0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees += speed * delta
	
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn") # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit() # Replace with function body.
