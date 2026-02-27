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

func draw_cone(pos: Vector3, direction: Vector3, height: float = 8.0, cone_angle: float = 45.0, color: Color = Color(1, 0.5, 0, 0.3), duration: float = 1.0) -> void:
	var mesh_instance = MeshInstance3D.new()
	
	var cone_mesh = CylinderMesh.new() 
	
	var half_angle = deg_to_rad(cone_angle * 0.5)
	var cone_radius = height * tan(half_angle)
	
	cone_mesh.top_radius = 0.0
	cone_mesh.bottom_radius = cone_radius
	cone_mesh.height = height
	mesh_instance.mesh = cone_mesh
	
	var material = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = color
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	mesh_instance.material_override = material
	
	add_child(mesh_instance)
	
	mesh_instance.global_position = pos
	
	mesh_instance.look_at(pos + direction, Vector3.UP)
	

	mesh_instance.rotate_object_local(Vector3.RIGHT, PI / 2.0)
	
	mesh_instance.translate_object_local(Vector3(0, -height / 2.0, 0))
	
	get_tree().create_timer(duration).timeout.connect(mesh_instance.queue_free)
