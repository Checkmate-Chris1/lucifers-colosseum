# GameState.gd
# A basic singleton that holds global game variables and globally useful functions

extends Node

# Game Variables
const player_fov = 75.0 ## Player's field of view in degrees

var mouse_sensitivity := 0.2
var player_inventory = ['Spine Whip']
var slam_multiplier = 2
var dash_speed: float = 5.0
const dash_cd = 1 ## Dash cooldown in seconds

# Game Functions
func reset():
	# reset the game here
	pass
