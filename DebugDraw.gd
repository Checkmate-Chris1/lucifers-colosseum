extends Node

func draw_sphere(pos: Vector3, radius: float = 0.5, color: Color = Color(1, 0, 0, 0.3), duration: float = 1.0) -> void:
	var mesh_instance = MeshInstance3D.new()
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = radius
	sphere_mesh.height = radius * 2.0
	mesh_instance.mesh = sphere_mesh
	
	var material = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = color
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	mesh_instance.material_override = material
	
	add_child(mesh_instance)
	mesh_instance.global_position = pos
	
	get_tree().create_timer(duration).timeout.connect(mesh_instance.queue_free)
