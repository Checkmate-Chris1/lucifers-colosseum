extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.wave_end.connect(_upgrade_ui)
	print('card_upgrade_readys')
	
func _upgrade_ui():
	print("UPGRADE!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
