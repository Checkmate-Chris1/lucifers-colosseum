extends Control

@onready var round_label = $Label

func _ready():
	Events.round_changed.connect(_on_round_changed)
	Events.game_over.connect(hide)
	round_label.text = "Wave 1"

func _on_round_changed(new_round: int):
	round_label.text = "Wave " + str(new_round)
	
	var tween = create_tween()
	round_label.scale = Vector2(1.5, 1.5)
	tween.tween_property(round_label, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_BOUNCE)
