extends Node3D

@export var weapons: Array[Weapon] = []
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
	elif Input.is_action_just_pressed("scroll_weapon_up"):
		cycle_weapon_backward()
	elif Input.is_action_just_pressed("scroll_weapon_down"):
		cycle_weapon_forward()
	elif Input.is_action_just_pressed("reload_weapon"):
		reload()
	elif Input.is_action_pressed("fire_weapon"):
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
	
	current_weapon.ammo -= 1
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
	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	if result:
		var collider = result.get("collider")
		if collider and collider.has_method("take_damage"):
			collider.take_damage(10)
		print("Hit: %s" % collider)


func _on_fire_timer_end() -> void:
	ready_to_shoot = true
