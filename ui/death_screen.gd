extends Control

func _ready() -> void:
	visible = false
	Events.game_over.connect(_on_game_over)

func _on_game_over():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true

func _on_respawn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title_screen.tscn")
