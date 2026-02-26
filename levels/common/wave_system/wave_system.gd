extends Node3D


@export var wave_length: float = 25.0
@export var wave_grace_period: float = 10.0
@export var enemy_weights: Dictionary[PackedScene, float]

var enemy_spawners: Array[EnemySpawner] = []

func _ready() -> void:
	_update_spawners()
	spawn_wave(3)

func spawn_wave(enemy_count: int) -> void:
	GameState.wave_number += 1
	Events.wave_start.emit()
	get_tree().create_timer(wave_length, false).timeout.connect(_on_wave_end)
	for __ in range(enemy_count):
		_spawn_enemy()
		await get_tree().create_timer(5.0/enemy_count, false).timeout
		
func _on_wave_end() -> void:
	Events.wave_end.emit(false) # FIX: PERFECT WAVES ARE NOT YET POSSIBLE
	await get_tree().create_timer(wave_grace_period, false).timeout
	# Enemy count goes 3, 5, 6, 7, 8, etc.
	spawn_wave(3+GameState.wave_number)
		
func _spawn_enemy() -> void:
	var spawner_index = randi() % len(enemy_spawners)
	var selected_enemy = _get_from_weighted_values(enemy_weights)
	enemy_spawners[spawner_index].spawn_enemy(selected_enemy)

func _get_from_weighted_values(weight_dict: Dictionary):
	var total_weight = _sum(weight_dict.values())

	var pick = randf() * total_weight
	var current_weight = 0.0

	for enemy_scene in weight_dict.keys():
		current_weight += weight_dict[enemy_scene]
		if current_weight >= pick:
			return enemy_scene

func _update_spawners() -> void:
	enemy_spawners = []
	for child in get_children():
		if child is EnemySpawner:
			enemy_spawners.append(child)

func _sum(array: Array):
	var sum = 0
	for item in array:
		sum += item
	return sum
