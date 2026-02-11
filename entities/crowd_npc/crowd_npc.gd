extends Node3D

@onready var sprite: Sprite3D = $Sprite3D

@export var jump_height: float = 0.5
@export var jump_duration: float = 0.2
@export var min_jump_wait: float = 0.5
@export var max_jump_wait: float = 2.0
@export var frame_time: float = 0.12

const NPC_FRAMES: Array = [
	[
		preload("res://art/crowd_npcs/crowd_npc_1/IMG_7721.png"),
		preload("res://art/crowd_npcs/crowd_npc_1/IMG_7722.png"),
		preload("res://art/crowd_npcs/crowd_npc_1/IMG_7723.png"),
		preload("res://art/crowd_npcs/crowd_npc_1/IMG_7724.png"),
	],
	[
		preload("res://art/crowd_npcs/crowd_npc_2/IMG_7725.png"),
		preload("res://art/crowd_npcs/crowd_npc_2/IMG_7726.png"),
		preload("res://art/crowd_npcs/crowd_npc_2/IMG_7727.png"),
		preload("res://art/crowd_npcs/crowd_npc_2/IMG_7728.png"),
	],
	[
		preload("res://art/crowd_npcs/crowd_npc_3/IMG_7729.png"),
		preload("res://art/crowd_npcs/crowd_npc_3/IMG_7730.png"),
		preload("res://art/crowd_npcs/crowd_npc_3/IMG_7731.png"),
		preload("res://art/crowd_npcs/crowd_npc_3/IMG_7732.png"),
	],
]

var _current_frames: Array = []
var _current_frame_index: int = 0
var _frame_accumulator: float = 0.0

var _base_y: float
var _rng := RandomNumberGenerator.new()
var _jump_tween: Tween


func _ready() -> void:
	_rng.randomize()

	_base_y = position.y

	_pick_random_npc()
	
	# randomize frames
	_current_frame_index = _rng.randi_range(0, max(_current_frames.size() - 1, 0))
	if _current_frames.size() > 0:
		sprite.texture = _current_frames[_current_frame_index]

	_schedule_next_jump()


func _process(delta: float) -> void:
	# frame animations
	if _current_frames.size() == 0:
		return

	_frame_accumulator += delta
	if _frame_accumulator >= frame_time:
		_frame_accumulator = 0.0
		_current_frame_index = (_current_frame_index + 1) % _current_frames.size()
		sprite.texture = _current_frames[_current_frame_index]


func _pick_random_npc() -> void:
	if NPC_FRAMES.size() == 0:
		return

	var npc_index := _rng.randi_range(0, NPC_FRAMES.size() - 1)
	_current_frames = NPC_FRAMES[npc_index]
	_current_frame_index = 0


func _schedule_next_jump() -> void:
	var wait_time := _rng.randf_range(min_jump_wait, max_jump_wait)
	_start_jump_after_delay(wait_time)


func _start_jump_after_delay(wait_time: float) -> void:
	await get_tree().create_timer(wait_time).timeout
	_do_jump()
	_schedule_next_jump()


func _do_jump() -> void:
	if jump_height <= 0.0 or jump_duration <= 0.0:
		return

	if _jump_tween and _jump_tween.is_running():
		_jump_tween.kill()

	_jump_tween = create_tween()
	_jump_tween.tween_property(self, "position:y", _base_y + jump_height, jump_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	_jump_tween.tween_property(self, "position:y", _base_y, jump_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
