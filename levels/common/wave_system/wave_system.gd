extends Node3D


@export var wave_length: float = 25.0
@export var wave_grace_period: float = 10.0
@export var enemy_weights: Dictionary[PackedScene, float]

var enemy_spawners: Array[EnemySpawner]
var wave_number := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.start_game.connect(spawn_wave)
	get_children()


func spawn_wave() -> void:
	var enemy_count = 3 # Fixed enemy number for now
	for __ in range(enemy_count):
		_spawn_enemy()
		
func _spawn_enemy() -> void:
	pass
