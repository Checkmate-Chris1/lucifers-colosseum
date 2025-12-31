extends Node3D


func _on_area_body_entered(body: Node3D) -> void:
	if "player" in body.get_groups():
		Events.respawn.emit()
