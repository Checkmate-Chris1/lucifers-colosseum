extends Node3D

@onready var player = $Player
@onready var health_bar = $HealthBar 

var previous_health: float = 0.0
var flash_rect: ColorRect
var flash_canvas: CanvasLayer

func _ready():
	health_bar.init_health(player.current_health, player.HEALTH)
	previous_health = player.current_health
	player.health_changed.connect(_on_player_health_changed)

	flash_canvas = CanvasLayer.new()
	flash_canvas.layer = 3
	add_child(flash_canvas)
	
	flash_rect = ColorRect.new()
	flash_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	flash_rect.color = Color(1, 0, 0, 0)
	flash_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	flash_canvas.add_child(flash_rect)

func _on_player_health_changed(new_health: float):
	health_bar._set_health(new_health)
	if new_health < previous_health:
		_play_damage_effects()
	previous_health = new_health


func _play_damage_effects():
	var flash_tween = create_tween()
	flash_rect.color.a = 0.4
	flash_tween.tween_property(flash_rect, "color:a", 0.0, 0.25) 
	var camera = player.get_node("CameraController/Camera")
	if camera:
		var shake_tween = create_tween()
		var shake_strength = 0.15
		var shake_speed = 0.04
	
		for i in range(5):
			var rand_offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
			shake_tween.tween_property(camera, "h_offset", rand_offset.x, shake_speed)
			shake_tween.parallel().tween_property(camera, "v_offset", rand_offset.y, shake_speed)
		
		shake_tween.tween_property(camera, "h_offset", 0.0, shake_speed)
		shake_tween.parallel().tween_property(camera, "v_offset", 0.0, shake_speed)
