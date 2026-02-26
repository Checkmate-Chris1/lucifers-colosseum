extends Control

@onready var spin_sprite = $MainStack/SpinWindow/SpinSprite
@onready var real_icon = $MainStack/SpinWindow/Real
@onready var info_panel = $MainStack/InfoPanel
@onready var name_label = $MainStack/InfoPanel/VBoxContainer/UpgradeName
@onready var stats_label = $MainStack/InfoPanel/VBoxContainer/StatList

var is_spinning = false

var event : Signal
var value : int






func _ready():
	info_panel.modulate.a = 0
	real_icon.hide()

func init_slot(data: Dictionary, delay: float):
	if data.has("icon"):
		real_icon.texture = data.icon
	
	event = data['event']
	value = data['value']
	name_label.text = data.name
	stats_label.bbcode_enabled = true
	stats_label.text = "[center]" + data.stats + "[/center]"
	await get_tree().create_timer(delay).timeout
	
	is_spinning = true
	spin_sprite.show()
	spin_sprite.play("spin_blur")

	await get_tree().create_timer(1.2).timeout
	
	stop_spin_and_reveal()

func stop_spin_and_reveal():
	spin_sprite.stop()
	spin_sprite.hide()
	
	real_icon.show()
	is_spinning = false

	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(info_panel, "modulate:a", 1.0, 0.4)


func _on_slot_pressed() -> void:
	event.emit(value)
	Events.upgrade_chosen.emit()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
