extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	Events.start_game.emit()

func _on_exit_pressed() -> void:
	get_tree().quit() 

func _on_options_pressed() -> void:
	pass 

func _on_tutorial_pressed() -> void:
	$TutorialMenu.visible = true

func _on_exit_tutorial_pressed() -> void:
	$TutorialMenu.visible = false
