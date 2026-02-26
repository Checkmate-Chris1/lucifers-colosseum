extends Control


func _ready() -> void:
	Events.game_over.connect(_on_game_over)

func _on_game_over():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true

func _respawn():
	get_tree().paused = false
	Events.respawn.emit()
	
func _quit_game():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title_screen.tscn")
