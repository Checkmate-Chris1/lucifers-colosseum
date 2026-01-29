extends CanvasLayer

func _ready() -> void:
	visible = false
	$Options.visible = false
	$ExitOptions.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if $Options.visible:
			$Options.visible = false
			$ExitOptions.visible = false
			visible = true
		elif visible:
			hide_menu()
		else:
			show_menu()

func show_menu() -> void:
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 

func hide_menu() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_pressed() -> void:
	hide_menu()

func _on_options_pressed() -> void:
	visible = false
	$Options.visible = true
	$ExitOptions.visible = true
	
func _on_exit_options_pressed() -> void:
	$Options.visible = false
	$ExitOptions.visible = false
	visible = true

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")
