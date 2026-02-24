extends CanvasLayer

func _on_master_slider_value_changed(value: float) -> void:
	pass

func _on_sfx_slider_value_changed(value: float) -> void:
	pass
	
func _on_music_slider_value_changed(value: float) -> void:
	BackgroundMusicPlayer.volume_db = 30 * value - 30
	if value == 0:
		BackgroundMusicPlayer.volume_db = -80
	
