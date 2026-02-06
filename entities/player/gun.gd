extends Node3D


# Projectile refers to bullets shooting at finite speeds
# Raycast refers to hitscan "lasers" (most weapons)
# Can also add "conical" for flamethrowers
enum WeaponType {PROJECTILE, RAYCAST}

@export var bullet_scene: PackedScene
@export var fire_delay := 0.2
@export var reload_delay := 1
@export var max_ammo := 10
@export var weapon_type := WeaponType.RAYCAST
@export var range := 99 # larger than the diameter of the arena

var player: Node3D
var fire_timer := Timer.new()
var reload_timer := Timer.new()
var ready_to_shoot := true
var ammo := max_ammo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	
	add_child(fire_timer)
	fire_timer.wait_time = fire_delay
	fire_timer.one_shot = true
	fire_timer.timeout.connect(_on_fire_timer_end)
	
	add_child(reload_timer)
	reload_timer.wait_time = reload_delay
	reload_timer.one_shot = true
	reload_timer.timeout.connect(_on_reload_timer_end)



func _process(delta: float) -> void:
	if Input.is_action_pressed("fire_weapon"):
		fire()
	elif Input.is_action_just_pressed("reload_weapon"):
		reload()

func fire() -> void:
	if not ready_to_shoot:
		return
	if ammo <= 0:
		# this should be replaced with some in-game notification
		# or maybe this auto-triggers a reload
		print('out of ammo')
		return
	
	if weapon_type == WeaponType.PROJECTILE:
		shoot_bullet()
	elif weapon_type == WeaponType.RAYCAST:
		shoot_ray()
		
	ammo -= 1
	ready_to_shoot = false
	fire_timer.start()

func reload() -> void:
	ready_to_shoot = false
	reload_timer.start()

func shoot_bullet() -> void:
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_transform = player.get_node('CameraController/Camera').global_transform

func shoot_ray() -> void:
	var space_state = get_world_3d().direct_space_state
	var cam = player.get_node('CameraController/Camera')
	var mouse_pos = get_viewport().size / 2 # center of screen, i.e. the crosshairs
	
	var origin = cam.global_position
	var end = origin + cam.project_ray_normal(mouse_pos) * range
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	
	# this returns a dictionary of info on the point that the ray collided with, including its 
	# global position and the type of object the collision was with
	var result = space_state.intersect_ray(query)
	
	




func _on_fire_timer_end() -> void:
	ready_to_shoot = true

func _on_reload_timer_end() -> void:
	ammo = max_ammo
	ready_to_shoot = true
