extends Node3D

@export var bullet_scene: PackedScene
@export var fire_rate := 0.2

var player: Node3D


var timer := Timer.new()
var ready_to_shoot := true
@export var max_ammo := 10
var ammo := max_ammo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(timer)
	timer.wait_time = fire_rate
	timer.one_shot = true
	timer.timeout.connect(_on_timer_end)
	player = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("fire_weapon"):
		fire()
	elif Input.is_action_just_pressed("reload_weapon"):
		reload()

func fire() -> void:
	if not ready_to_shoot:
		return
	if ammo > 0:
		create_bullet()
		ammo -= 1
		ready_to_shoot = false
		timer.start()
	else:
		print('out of ammo')

func create_bullet() -> void:
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_transform = player.get_node('CameraController/Camera').global_transform
	#bullet.global_transform = player.global_transform
	#print(player.get_child(2).get_child(0).global_transform)


func reload() -> void:
	ammo = max_ammo
	print('reloaded')

func _on_timer_end() -> void:
	ready_to_shoot = true
