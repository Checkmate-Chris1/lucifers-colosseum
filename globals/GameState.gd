# GameState.gd
# A basic singleton that holds global game variables and globally useful functions

extends Node

# Game Variables
const player_fov = 75.0 ## Player's field of view in degrees

var mouse_sensitivity := 0.2
var player_inventory = ['Spine Whip']
var slam_multiplier = 20 ## A multiplier for the player's slam damage
var slam_size = 1 ## A multiplier from the default slam area diameter
var dash_speed: float = 5.0
const dash_cd = 1 ## Dash cooldown in seconds

var master_volume := 1.0
var master_volume_muted := false
var music_volume := 1.0
var music_volume_muted := false
var sfx_volume := 1.0
var sfx_volume_muted := false

# Game Functions
func reset():
	# reset the game here
	pass
