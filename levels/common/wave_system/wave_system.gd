extends Node3D


@export var wave_length: float = 25.0
@export var wave_grace_period: float = 10.0
@export var enemy_weights: Dictionary[PackedScene, float]

var enemy_spawners: Array[EnemySpawner] = []

# Called when the node enters the scene tree for the first time.
@export var TEMP: PackedScene
func _ready() -> void:
	Events.start_game.connect(spawn_wave)
	for child in get_children():
		if child is EnemySpawner:
			enemy_spawners.append(child)
	enemy_spawners[0].spawn_enemy(TEMP)

func spawn_wave() -> void:
	var enemy_count = 3 # Fixed enemy number for now
	for __ in range(enemy_count):
		_spawn_enemy()
		
func _spawn_enemy() -> void:
	var spawner_index = randi() % len(enemy_spawners)
	var selected_enemy = _get_from_weighted_values(enemy_weights)
	enemy_spawners[0].spawn_enemy(TEMP)

func _get_from_weighted_values(weight_dict: Dictionary):
	var total_weight = _sum(weight_dict.values())

	var pick = randf() * total_weight
	var current_weight = 0.0

	for enemy_scene in weight_dict.keys():
		current_weight += weight_dict[enemy_scene]
		if current_weight >= pick:
			return enemy_scene

func _sum(array: Array):
	var sum = 0
	for item in array:
		sum += item
	return sum
