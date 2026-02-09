extends CanvasLayer

@export var slot_scene: PackedScene
@onready var slot_container = $MarginContainer/VBoxContainer/SlotContainer
@onready var title_label = $MarginContainer/VBoxContainer/Label

var upgrade_pool = [
	{"name": "Speed Pulse", "stats": "+15% Move Speed", "desc": "Zotting around fast."},
	{"name": "Heavy Hitter", "stats": "+25% Damage", "desc": "Slow but deadly."},
	{"name": "Shield Tech", "stats": "+1 Max Shield", "desc": "Extra layer of safety."},
	{"name": "Quick Loader", "stats": "-20% Reload Time", "desc": "Keep the fire up."}
]

func _ready():
	pass

func open_upgrade_menu(is_perfect_wave: bool):	
	for child in slot_container.get_children():
		child.queue_free()
		
	var count = 5 if is_perfect_wave else 3
	title_label.text = "PERFECT WAVE! CHOOSE 1" if is_perfect_wave else "PICK AN UPGRADE"
	for i in range(count):
		var new_slot = slot_scene.instantiate()
		slot_container.add_child(new_slot)
		var random_data = upgrade_pool.pick_random()
		new_slot.init_slot(random_data, i * 0.5)
	self.show()
