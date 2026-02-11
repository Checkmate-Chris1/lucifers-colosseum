extends Node3D

const CROWD_NPC_SCENE := preload("res://entities/crowd_npc/crowd_npc.tscn")

@export var center := Vector3.ZERO

# how many tiers of the colosseum
@export var level_count := 5
# smaller radius on the lowest tier
@export var radius_inner := 27.0
# larger radius on the highest tier
@export var radius_outer := 45.0


@export var npcs_per_ring := 32
@export var level_height_base := 10
@export var level_height_step := 2.5
@export var tier_offset_amount := 0.5  # Angular offset for alternating tiers (in radians)

func _ready() -> void:
	_spawn_crowd()

func _spawn_crowd() -> void:
	for level in level_count:
		var t := (level + 0.5) / float(level_count)
		var radius = lerp(radius_inner, radius_outer, t)
		var height := level_height_base + level * level_height_step
		var angle_step := TAU / float(npcs_per_ring)
		
		# offset every other tier so they dont line up
		var tier_offset := tier_offset_amount if level % 2 == 1 else 0.0
		
		for i in npcs_per_ring:
			var angle := i * angle_step + tier_offset
			var pos := center + Vector3(cos(angle) * radius, height, sin(angle) * radius)
			var npc: Node3D = CROWD_NPC_SCENE.instantiate()
			npc.position = pos
			
			# face toward center
			npc.rotation.y = PI / 2.0 - angle
			
			add_child(npc)
