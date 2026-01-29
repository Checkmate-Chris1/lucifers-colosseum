extends CanvasLayer

func _ready() -> void:
	$Options.visible = false
	$ExitOptions.visible = false

func _on_options_pressed() -> void:
	$Menu.visible = false
	$Options.visible = true
	$ExitOptions.visible = true
	
func _on_exit_options_pressed() -> void:
	$Menu.visible = true
	$Options.visible = false
	$ExitOptions.visible = false
