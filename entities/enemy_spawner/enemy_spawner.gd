extends Node3D


func spawn_enemy(enemy: PackedScene):
	var enemy_instance = enemy.instantiate()
	enemy_instance.global_position = global_position
	add_child(enemy_instance)
