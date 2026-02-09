extends Node3D


func spawn_enemy(enemy: PackedScene):
	var enemy_instance = enemy.instantiate()
	add_child(enemy_instance)
	enemy_instance.global_position = global_position
	
