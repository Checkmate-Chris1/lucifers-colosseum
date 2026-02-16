extends Node3D

@export var weapons: Array[Weapon] = []
@export var tracerMaterial: StandardMaterial3D
var current_weapon_index := 0
var current_weapon: Weapon

var player: Node3D
var fire_timer := Timer.new()
var reload_timer := Timer.new()
var ready_to_shoot := true
var reloading := false

# weapon model instances
var weapon_models: Dictionary = {}  # weapon_name -> model_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	
	if weapons.is_empty():
		push_error("No weapons configured!")
		return
	
	# Instantiate all weapon models and hide them
	for weapon in weapons:
		if weapon.model:
			var model = weapon.model.instantiate()
			add_child(model)
			weapon_models[weapon.weapon_name] = model
			model.visible = false
	
	# Set initial weapon
	current_weapon = weapons[0]
	set_weapon_visibility()
	
	add_child(fire_timer)
	fire_timer.one_shot = true
	fire_timer.timeout.connect(_on_fire_timer_end)
	
	add_child(reload_timer)
	reload_timer.one_shot = true
	reload_timer.timeout.connect(_on_reload_timer_end)
	
	update_fire_rate()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_proj"):
		switch_to_weapon_by_type("projectile")
	elif Input.is_action_just_pressed("switch_ray"):
		switch_to_weapon_by_type("raycast")
	elif Input.is_action_just_pressed("switch_aoe"):
		switch_to_weapon_by_type("aoe")
	elif Input.is_action_just_pressed("switch_melee"):
		switch_to_weapon_by_type("melee")
	elif Input.is_action_just_pressed("scroll_weapon_up"):
		cycle_weapon_backward()
	elif Input.is_action_just_pressed("scroll_weapon_down"):
		cycle_weapon_forward()
	elif Input.is_action_just_pressed("reload_weapon"):
		reload()
	
	if Input.is_action_pressed("fire_weapon"):
		fire()

func fire() -> void:
	if not ready_to_shoot or reloading or not current_weapon:
		return
	
	if current_weapon.ammo <= 0:
		print("Out of ammo")
		return
	
	if current_weapon.weapon_type == "projectile":
		shoot_bullet()
	elif current_weapon.weapon_type == "raycast":
		shoot_ray()
	elif current_weapon.weapon_type == "aoe":
		shoot_aoe()
	elif current_weapon.weapon_type == "melee":
		shoot_melee()
		
	if current_weapon.weapon_type != "melee":
		current_weapon.ammo -= 1
	print(current_weapon.weapon_name, ' ', current_weapon.ammo,'/', current_weapon.max_ammo)
	ready_to_shoot = false
	fire_timer.wait_time = current_weapon.fire_delay
	fire_timer.start()

func reload() -> void:
	if not current_weapon or reloading:
		return
	
	reloading = true
	ready_to_shoot = false
	fire_timer.stop()  # optional but correct
	reload_timer.wait_time = current_weapon.reload_delay
	reload_timer.start()

func _on_reload_timer_end() -> void:
	if current_weapon:
		current_weapon.ammo = current_weapon.max_ammo
	
	reloading = false
	ready_to_shoot = true



func switch_to_weapon_by_type(weapon_type: String) -> void:
	for i in range(weapons.size()):
		if weapons[i].weapon_type == weapon_type:
			switch_to_weapon(i)
			return


func switch_to_weapon(index: int) -> void:
	if index < 0 or index >= weapons.size():
		return
	
	if index == current_weapon_index:
		return
	
	current_weapon_index = index
	current_weapon = weapons[current_weapon_index]
	reloading = false
	ready_to_shoot = true
	
	print("Switched to %s" % current_weapon.weapon_name)
	
	set_weapon_visibility()
	update_fire_rate()


func cycle_weapon_forward() -> void:
	var next = (current_weapon_index + 1) % weapons.size()
	switch_to_weapon(next)


func cycle_weapon_backward() -> void:
	var prev = (current_weapon_index - 1 + weapons.size()) % weapons.size()
	switch_to_weapon(prev)


func set_weapon_visibility() -> void:
	for weapon_name in weapon_models:
		weapon_models[weapon_name].visible = (weapon_name == current_weapon.weapon_name)


func update_fire_rate() -> void:
	if current_weapon:
		fire_timer.wait_time = current_weapon.fire_delay


func shoot_bullet() -> void:
	if not current_weapon.bullet_scene:
		push_error("Bullet scene not set for %s" % current_weapon.weapon_name)
		return
	
	var bullet = current_weapon.bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_transform = player.get_node('CameraController/Camera').global_transform
	bullet.position += -bullet.global_transform.basis.z * 0.5  # offset forward to avoid hitting player


func shoot_ray() -> void:
	var space_state = get_world_3d().direct_space_state
	var cam = player.get_node('CameraController/Camera')
	var mouse_pos = get_viewport().size / 2  # center of screen
	
	var origin = cam.global_position
	var end = origin + cam.project_ray_normal(mouse_pos) * current_weapon.range
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	
	# Create temporary cylindrical bullet tracer
	var tracer = CSGCylinder3D.new()
	get_parent().add_sibling(tracer)
	tracer.position = origin + (end-origin)/2 - Vector3(1, 0, 0)
	tracer.material = tracerMaterial
	tracer.radius = 0.2
	get_tree().create_tween().tween_callback(tracer.queue_free).set_delay(1)
	tracer.look_at(origin, Vector3.FORWARD)
	tracer.rotate_object_local(Vector3.RIGHT, PI/2)
	tracer.height = origin.distance_to(end)
	
	var result = space_state.intersect_ray(query)
	if result:
		var collider = result.get("collider")
		if collider is Enemy:
			collider.damage(current_weapon.bullet_damage)
		print("Hit: %s" % collider)


func shoot_aoe() -> void:
	# AOE attack works similarly to melee but is automatic and uses cone/range
	if not current_weapon is AOEWeapon:
		return
	
	var aoe_w: AOEWeapon = current_weapon
	var cam = player.get_node('CameraController/Camera')
	var origin = cam.global_position
	var direction = -cam.global_transform.basis.z
	
	# sphere around midpoint of the cone
	var space_state = get_world_3d().direct_space_state
	var shape_query = PhysicsShapeQueryParameters3D.new()
	var sphere = SphereShape3D.new()
	sphere.radius = aoe_w.aoe_range
	shape_query.shape = sphere

	var hit_position = origin + direction * (aoe_w.aoe_range * 0.5)
	shape_query.transform.origin = hit_position

	var results = space_state.intersect_shape(shape_query)
	# precompute cosine of half-angle for cone check
	var cos_threshold = cos(deg_to_rad(aoe_w.cone_angle * 0.5))
	
	# debug visualization
	#DebugDraw.draw_cone(origin, direction, aoe_w.aoe_range, aoe_w.cone_angle, Color(1, 0.5, 0, 0.3), fire_timer.wait_time)

	for result in results:
		var collider = result.collider
		var direction_to_enemy = (collider.global_position - origin).normalized()
		var forward_dot = direction.dot(direction_to_enemy)
		if forward_dot >= cos_threshold:
			if collider is Enemy:
				# apply damage scaled by how often this function is called
				collider.damage(aoe_w.bullet_damage * fire_timer.wait_time)
				collider.apply_burn(aoe_w.burn_damage_per_second, aoe_w.burn_duration)

func shoot_melee() -> void:
	if not current_weapon is MeleeWeapon:
		return
	
	var melee_w: MeleeWeapon = current_weapon
	var cam = player.get_node('CameraController/Camera')
	var origin = cam.global_position
	var direction = -cam.global_transform.basis.z
	
	# use sphere to find colliders in melee range
	var space_state = get_world_3d().direct_space_state
	var shape_query = PhysicsShapeQueryParameters3D.new()
	var sphere = SphereShape3D.new()
	sphere.radius = melee_w.melee_range
	shape_query.shape = sphere
	
	var hit_position = origin + direction * (melee_w.melee_range * 0.5)
	shape_query.transform.origin = hit_position
	
	#DebugDraw.draw_cone(origin, direction, melee_w.melee_range, 90.0, Color(1, 0, 0, 0.3), 0.5)

	var results = space_state.intersect_shape(shape_query)
	
	for result in results:
		var collider = result.collider
		#cone math
		var direction_to_enemy = (collider.global_position - origin).normalized()
		var forward_dot = direction.dot(direction_to_enemy)
		# increase 0.0 to narrow cone
		if forward_dot > 0.0:
			if collider is Enemy:
				collider.damage(melee_w.bullet_damage)
				var knockback_dir = (collider.global_position - origin).normalized()
				collider.apply_knockback(knockback_dir, melee_w.knockback_distance)
				print("Melee hit: %s" % collider)


func _on_fire_timer_end() -> void:
	ready_to_shoot = true
