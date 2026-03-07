class_name Hitbox
extends Area3D

@export var entity: Entity
@export var damage_multiplier: float = 1.0 

func _ready() -> void:
	var current_node = self
	while current_node != null:
		if current_node is Entity:
			entity = current_node
			break
		current_node = current_node.get_parent()
	if not entity:
		print("no root entity")

func hit(base_damage: float, source: String = "weapon"):
	if entity:
		var final_damage = base_damage * damage_multiplier
		if damage_multiplier == 2.0:
			Events.headshot.emit()
		entity.damage(final_damage, source)
		
