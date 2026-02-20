# Events.gd
# This is an event bus that should hold all the signals that might be used between various applications.

extends Node

signal respawn ## Respawn the player back to the starting position
signal start_game ## Starts/restarts the main game
signal wave_start ## Triggered after wave grace period
signal wave_end ## Triggered when all enemies die or wave timer ends, whichever comes first
signal toggle_pause ## Triggered by pause UI
signal game_over ## Signal when the game is over by death
