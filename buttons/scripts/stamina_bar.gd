extends ProgressBar

@onready var timer = $Timer
@onready var damageBar = $DamageBar
@onready var hBar = $HealthBar
@onready var hp_label = $HPLabel

var max_health = 0 : set = _set_max_health
var health = 0 : set = _set_health


func _set_max_health(new_max):
	max_health = new_max
	hBar.max_value = max_health
	damageBar.max_value = max_health
	_update_label()

func _set_health(new_health):
	var prevHealth = health
	health = clamp(new_health, 0, max_health) 
	hBar.value = health
	
	_update_label()
	if health < prevHealth:
		timer.start()
	else:
		damageBar.value = health

func init_health(_health, _max_health):
	max_health = _max_health
	health = _health
	damageBar.value = health

func _update_label():
	if hp_label:
		hp_label.text = str(health) + " / " + str(max_health)

func _on_timer_timeout() -> void:
	damageBar.value = health
