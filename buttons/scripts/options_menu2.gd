extends CanvasLayer

func _on_master_slider_value_changed(value: float) -> void:
	GameState.master_volume = value
	Events.change_sound_volume.emit()

func _on_sfx_slider_value_changed(value: float) -> void:
	GameState.sfx_volume = value
	Events.change_sound_volume.emit()
	
func _on_music_slider_value_changed(value: float) -> void:
	GameState.music_volume = value
	Events.change_sound_volume.emit()
	
