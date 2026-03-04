extends Node3D


@export var wave_length: float = 25.0
@export var wave_grace_period: float = 10.0
@export var enemy_weights: Dictionary[PackedScene, float]

var enemy_spawners: Array[EnemySpawner] = []

var enemy_count := 0

func _ready() -> void:
	Events.enemy_died.connect(_enemy_death_process)
	_update_spawners()
	spawn_wave(10)

func _enemy_death_process():
	enemy_count -= 1
	if enemy_count == 0:
		_on_wave_end()
	
	
		
func spawn_wave(enemy_count: int) -> void:
	#print('spawn wave')
	GameState.wave_number += 1
	Events.wave_start.emit()
	for __ in range(enemy_count):
		_spawn_enemy()
		await get_tree().create_timer(5.0/enemy_count, false).timeout
	print(enemy_count)
		
func _on_wave_end() -> void:
	print('wave end')
	enemy_count = 0
	Events.wave_end.emit(false)
	await get_tree().create_timer(wave_grace_period, false).timeout
	# Enemy count goes 10, 14, 16, 18 etc.
	spawn_wave(10+2*GameState.wave_number)
		
func _spawn_enemy() -> void:
	#print('spawn_enemy')
	await _update_spawners()
	#print(enemy_spawners)
	var spawner_index = randi() % len(enemy_spawners)
	var selected_enemy = _get_from_weighted_values(enemy_weights)
	enemy_spawners[spawner_index].spawn_enemy(selected_enemy)
	enemy_count += 1

func _get_from_weighted_values(weight_dict: Dictionary):
	var total_weight = _sum(weight_dict.values())

	var pick = randf() * total_weight
	var current_weight = 0.0

	for enemy_scene in weight_dict.keys():
		current_weight += weight_dict[enemy_scene]
		if current_weight >= pick:
			return enemy_scene

func _update_spawners() -> void:
	#print('update spawners')
	enemy_spawners = []
	for child in get_children():
		if child is EnemySpawner or child is Marker3D:
			enemy_spawners.append(child)

func _sum(array: Array):
	var sum = 0
	for item in array:
		sum += item
	return sum
