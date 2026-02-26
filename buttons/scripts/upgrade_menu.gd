extends CanvasLayer

@export var slot_scene: PackedScene
@onready var slot_container = $MarginContainer/VBoxContainer/SlotContainer
@onready var title_label = $MarginContainer/VBoxContainer/Label

const health_boost  := [10, 15]
const gp_size_boost := [10, 15] # 
const gp_dmg_boost  := [10, 15] # Ground Pound Damage Boost
const speed_boost   := [10, 15] # Player Spped Boost
const rg_dmg_boost  := [10, 15] # Railgun Damage Boost
const rg_size_boost := [10, 15]
const sw_size_boost := [10, 15]
const sw_dmg_boost  := [10, 15]
const ft_dmg_boost  := [10, 15]
const ft_size_boost := [10, 15]


var placeholder_upgrade_pool = [
	{"name": "Speed Pulse", "stats": "+15% Move Speed", "desc": "Zotting around fast."},
	{"name": "Heavy Hitter", "stats": "+25% Damage", "desc": "Slow but deadly."},
	{"name": "Shield Tech", "stats": "+1 Max Shield", "desc": "Extra layer of safety."},
	{"name": "Quick Loader", "stats": "-20% Reload Time", "desc": "Keep the fire up."}
]

var upgrade_pool = [
	{"name": "Health Boost",            "stats": "+123 health",             "desc": "Take more punnishment",              "event": Events.UPGR_p_max_health_up,  'value' : 0},
	{"name": "Ground Pound Size Boost", "stats": "+123 ground pound size",  "desc": "larger poundings",                   "event": Events.UPGR_p_gp_radius_up,   'value' : 0},
	{"name": "Ground Pound DMG Boost",  "stats": "+123 ground pound dmg",   "desc": "harder poundings",                   "event": Events.UPGR_p_gp_dmg_up,      'value' : 0},
	{"name": "Speed Boost",             "stats": "+123 speed",              "desc": "Zotting around fast",                "event": Events.UPGR_p_speed_up,       'value' : 0},
	{"name": "Railgun DMG Boost",       "stats": "+123 railgun dmg",        "desc": "Railgun Thermal Core Improved",      "event": Events.UPGR_railgun_dmg_up,    'value' : 0},
	{"name": "Railgun Range Boost",     "stats": "+123 railgun range",      "desc": "Railgun System Effeciency Improved", "event": Events.UPGR_railgun_range_up, 'value' : 0},
	{"name": "Spine Whip DMG Boost",    "stats": "+123 spine whip dmg",     "desc": "Sharpened Vertebrae",                "event": Events.UPGR_spine_whip_dmg_up,  'value' : 0},
	{"name": "Spine Whip Range Boost",  "stats": "+123 spine whip range",   "desc": "More Vertebrae",                     "event": Events.UPGR_spine_whip_range_up, 'value' : 0},
	{"name": "Flamethrower DMG Boost",  "stats": "+123 flamethrower dmg",   "desc": "Hotter flames",                      "event": Events.UPGR_flamethrower_dmg_up, 'value' : 0},
	{"name": "Flamethrower Range Boost","stats": "+123 flamethrower range", "desc": "larger flames",                      "event": Events.UPGR_flamethrower_range_up, 'value' : 0}
	

	
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
		random_data = _get_upgr_value(random_data)
		new_slot.init_slot(random_data, i * 0.5)
	self.show()

func _get_upgr_value(card : Dictionary):
	match card['name']:
		'Health Boost':
			card['value'] = randi_range(health_boost[0], health_boost[1])
		'Ground Pound Size Boost':
			card['value'] = randi_range(gp_size_boost[0], gp_size_boost[1])
		'Ground Pound DMG Boost':
			card['value'] = randi_range(gp_dmg_boost[0], gp_dmg_boost[1])
		'Speed Boost':
			card['value'] = randi_range(speed_boost[0], speed_boost[1])
		'Railgun DMG Boost':
			card['value'] = randi_range(rg_dmg_boost[0], rg_dmg_boost[1])
		'Railgun Range Boost':
			card['value'] = randi_range(rg_size_boost[0], rg_size_boost[1])
		'Spine Whip DMG Boost':
			card['value'] = randi_range(sw_dmg_boost[0], sw_dmg_boost[1])
		'Spine Whip Range Boost':
			card['value'] = randi_range(sw_size_boost[0], sw_size_boost[1])
		'Flamethrower DMG Boost':
			card['value'] = randi_range(ft_dmg_boost[0], ft_dmg_boost[1])
		'Flamethrower Range Boost':
			card['value'] = randi_range(ft_size_boost[0], ft_size_boost[1])
			
	card['stats'] = "+" + str(card['value']) + '% ' + card['stats'].substr(5,-1)
	return card
	
